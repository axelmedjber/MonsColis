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

// Error handling
app.use(errorHandler);

// Start server
app.listen(port, () => {
  logger.info(`Server running on port ${port}`);
});
