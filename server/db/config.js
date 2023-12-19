// db/config.js
const { config } = require('../config/config');

module.exports = {
  development: {
    url: config.dbUrl,
    dialect: 'postgres',
    // Other development options...
  },
  production: {
    url: config.dbUrl,
    dialect: 'postgres',
    ssl: {
      rejectUnauthorized: false
    }
  }
};
