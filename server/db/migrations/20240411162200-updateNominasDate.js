'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.changeColumn(
      'nominas_semanales',
      'fecha_inicio_semana',
      {
        type: Sequelize.DATE,
      },
    );
    await queryInterface.changeColumn('nominas_semanales', 'fecha_fin_semana', {
      type: Sequelize.DATE,
    });
  },

  async down(queryInterface, Sequelize) {},
};
