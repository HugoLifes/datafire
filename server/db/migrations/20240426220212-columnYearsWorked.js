'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    /**
     * Add altering commands here.
     *
     * Example:
     * await queryInterface.createTable('users', { id: Sequelize.INTEGER });
     */

    await queryInterface.addColumn('trabajadores', 'years_worked', {
      type: Sequelize.INTEGER,
      allowNull: true,
      after: 'semanal_hours',
      defaultValue: 0, // Especifica dónde quieres que se añada la columna
    });
  },

  async down (queryInterface,) {
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
    await queryInterface.removeColumn('trabajadores', 'years_worked');
  }
};
