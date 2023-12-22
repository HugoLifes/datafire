const { Model, DataTypes, Sequelize } = require('sequelize');

const { PROJECT_TABLE } = require('./proyectos.model');
const { CUSTOMER_TABLE } = require('./cliente.model');

const PROJECT_CUSTOMER_TABLE = 'project_has_customers';

const ProjectCustomerSchema = {
  id: {
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
    type: DataTypes.INTEGER,
  },
  createdAt: {
    allowNull: false,
    type: DataTypes.DATE,
    field: 'create_at',
    defaultValue: Sequelize.NOW,
  },
  project_id: {
    field: 'project_id',
    allowNull: false,
    type: DataTypes.INTEGER,
    references: {
      model: PROJECT_TABLE,
      key: 'id',
    },
    onUpdate: 'CASCADE',
    onDelete: 'SET NULL',
  },
  customer_id: {
    field: 'customer_id',
    allowNull: false,
    type: DataTypes.INTEGER,
    references: {
      model: CUSTOMER_TABLE,
      key: 'id',
    },
    onUpdate: 'CASCADE',
    onDelete: 'SET NULL',
  },
  project_name: {
    type: DataTypes.STRING,
    allowNull: true,
    onUpdate: 'CASCADE',
    onDelete: 'SET NULL',
  },
  customer_name: {
    type: DataTypes.STRING,
    allowNull: true,
    onUpdate: 'CASCADE',
    onDelete: 'SET NULL',
  },
};

class ProjectCustomer extends Model {
  static associate(models) {
    this.belongsTo(models.Project, {
      foreignKey: 'project_id',
      as: 'project',
      onDelete: 'SET NULL',
      onUpdate: 'CASCADE',
    });
    this.belongsTo(models.Customer, {
      foreignKey: 'customer_id',
      as: 'customer',
      onDelete: 'SET NULL',
      onUpdate: 'CASCADE',
    });
  }

  static config(sequelize) {
    return {
      sequelize,
      tableName: PROJECT_CUSTOMER_TABLE,
      modelName: 'ProjectCustomer',
      timestamps: false,
    };
  }
}

module.exports = {
  PROJECT_CUSTOMER_TABLE,
  ProjectCustomerSchema,
  ProjectCustomer,
};
