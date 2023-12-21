'use strict';

const {
  PROJECT_CUSTOMER_TABLE,
  ProjectCustomerSchema,
} = require('../models/proyecto-cliente.model');

module.exports = {
  up: async (queryInterface) => {
    await queryInterface.addColumn(
      PROJECT_CUSTOMER_TABLE,
      'project_name',
      ProjectCustomerSchema.project_name,
    );
    await queryInterface.addColumn(
      PROJECT_CUSTOMER_TABLE,
      'customer_name',
      ProjectCustomerSchema.customer_name,
    );
  },

  down: async (queryInterface) => {
    await queryInterface.removeColumn(PROJECT_CUSTOMER_TABLE, 'project_name');
    await queryInterface.removeColumn(PROJECT_CUSTOMER_TABLE, 'customer_name');
  },
};
