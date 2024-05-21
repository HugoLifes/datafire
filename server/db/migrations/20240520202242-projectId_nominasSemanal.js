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
    await queryInterface.addColumn('nominas_semanales', 'project_id',{
      type: Sequelize.INTEGER,
      allowNull: true,
      after: 'id',
      defaultValue: 0, // Especifica dónde quieres que se añada la columna
      
    });  },

  async down (queryInterface,) {
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */

    await queryInterface.removeColumn('nominas_semanales','project_id')
  }
};
