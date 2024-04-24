'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.changeColumn('proyectos', 'ganancia', {
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue: 0,
    });

  },

  async down(queryInterface, Sequelize) {

  },
};
