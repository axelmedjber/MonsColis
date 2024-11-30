const express = require('express');
const router = express.Router();
const healthRouter = require('./health');

// Health check route
router.use('/health', healthRouter);

module.exports = router;
