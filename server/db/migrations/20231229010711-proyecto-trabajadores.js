'use strict';

const {
  PROJECT_WORKER_TABLE,
  ProjectWorkerSchema,
} = require('../models/proyecto-trabajador.model');

module.exports = {
  up: async (queryInterface) => {
    await queryInterface.createTable(PROJECT_WORKER_TABLE, ProjectWorkerSchema);
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable(PROJECT_WORKER_TABLE);
  },
};
