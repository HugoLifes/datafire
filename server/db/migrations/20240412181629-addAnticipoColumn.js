'use strict';

const { PROJECT_TABLE, ProjectSchema } = require('../models/proyectos.model');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Step 1: Add column as nullable
    await queryInterface.addColumn(PROJECT_TABLE, 'ganancia', {
      ...ProjectSchema.ganancia,
      allowNull: true,
    });

    // Step 2: Update existing records
    await queryInterface.sequelize.query(
      `UPDATE ${PROJECT_TABLE} SET ganancia = abonado - costo`,
    );

    // Step 3: Alter column to non-nullable
    await queryInterface.changeColumn(PROJECT_TABLE, 'ganancia', {
      ...ProjectSchema.ganancia,
      allowNull: false,
    });
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn(PROJECT_TABLE, 'anticipo');
    await queryInterface.removeColumn(PROJECT_TABLE, 'presupuesto');
    await queryInterface.removeColumn(PROJECT_TABLE, 'ganancia');
  },
};
