require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const swaggerUi = require('swagger-ui-express');
const { errorHandler } = require('./middleware/errorHandler');
const logger = require('./utils/logger');
const routes = require('./routes');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// API Documentation
app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(require('./swagger')));

// Routes
app.use('/api', routes);

// Health check route (outside /api for easier monitoring)
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Not Found' });
});

// Error handling
app.use(errorHandler);

// Start server
const server = app.listen(port, () => {
  logger.info(`Server running on port ${port}`);
});

// Handle shutdown gracefully
process.on('SIGTERM', () => {
  logger.info('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    logger.info('HTTP server closed');
    process.exit(0);
  });
});

module.exports = app; // Export for testing
