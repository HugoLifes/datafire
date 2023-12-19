'use strict';

const { PROJECT_TABLE, ProjectSchema } = require('../models/proyectos.model');

module.exports = {
  up: async (queryInterface) => {
    await queryInterface.createTable(PROJECT_TABLE, ProjectSchema);
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable(PROJECT_TABLE);
  }
};
