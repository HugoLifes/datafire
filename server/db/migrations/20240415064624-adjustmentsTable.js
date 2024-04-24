'use strict';

const {
  ADJUSTMENTS_TABLE,
  AdjustmentSchema,
} = require('../models/adjustmentsProject.models');

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable(ADJUSTMENTS_TABLE, AdjustmentSchema);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable(ADJUSTMENTS_TABLE);
  },
};
