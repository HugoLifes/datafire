'use strict';

const { PROJECT_TABLE, ProjectSchema } = require('../models/proyectos.model');

module.exports = {
  up: async (queryInterface) => {
    await queryInterface.addColumn(PROJECT_TABLE, "costo", ProjectSchema.costo);
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn(PROJECT_TABLE, "costo")
  }
};


