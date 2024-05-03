'use strict';

const { WorkerSchema, WORKER_TABLE } = require('../models/trabajadores.model');

module.exports = {
  up: async (queryInterface) => {
    await queryInterface.createTable(WORKER_TABLE, WorkerSchema);
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable(WORKER_TABLE);
  }
};
