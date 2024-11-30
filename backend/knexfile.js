require('dotenv').config();

const baseConfig = {
  client: 'pg',
  migrations: {
    directory: './database/migrations',
  },
  seeds: {
    directory: './database/seeds',
  },
  pool: {
    min: 2,
    max: 10,
  },
};

const environments = {
  development: {
    connection: {
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 5432,
      database: process.env.DB_NAME || 'monscolis',
      user: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD,
    },
  },
  test: {
    connection: {
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 5432,
      database: process.env.DB_NAME || 'monscolis_test',
      user: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD,
    },
  },
  staging: {
    connection: process.env.DATABASE_URL,
    pool: {
      min: 2,
      max: 10,
    },
    ssl: { rejectUnauthorized: false },
  },
  production: {
    connection: {
      host: process.env.DB_HOST,
      port: process.env.DB_PORT,
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
    },
    pool: {
      min: 2,
      max: 20,
    },
  },
};

const environment = process.env.NODE_ENV || 'development';
module.exports = { ...baseConfig, ...environments[environment] };
