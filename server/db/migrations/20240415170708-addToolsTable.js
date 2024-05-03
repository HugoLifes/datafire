'use strict';

const { TOOLS_TABLE, ToolsSchema } = require('../models/tools.model');

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable(TOOLS_TABLE, ToolsSchema);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable(TOOLS_TABLE);
  },
};
