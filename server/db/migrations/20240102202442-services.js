'use strict';

const { SERVICES_TABLE, ServiceSchema } = require('../models/servicios.model');

module.exports = {
  up: async (queryInterface) => {
    await queryInterface.createTable(SERVICES_TABLE, ServiceSchema);
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable(SERVICES_TABLE);
  },
};
