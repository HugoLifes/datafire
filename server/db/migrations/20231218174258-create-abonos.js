'use strict';

const { ABONOS_TABLE, AbonosSchema } = require('../models/abonos.model');

module.exports = {
  up: async (queryInterface) => {
    await queryInterface.createTable(ABONOS_TABLE, AbonosSchema);
  },

  down: async (queryInterface) => {
    await queryInterface.dropTable(ABONOS_TABLE);
  }
};
