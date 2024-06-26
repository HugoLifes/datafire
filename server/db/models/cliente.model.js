const { Model, DataTypes, Sequelize } = require('sequelize');

const CUSTOMER_TABLE = 'clientes';

const CustomerSchema = {
  id: {
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
    type: DataTypes.INTEGER,
  },
  name: {
    allowNull: false,
    type: DataTypes.STRING,
  },
  last_name: {
    allowNull: false,
    type: DataTypes.STRING,
  },
  company: {
    allowNull: false,
    type: DataTypes.STRING,
  },
  createdAt: {
    allowNull: false,
    type: DataTypes.DATE,
    field: 'create_at',
    defaultValue: Sequelize.NOW,
  },
};

class Customer extends Model {
  static associate(models) {
    this.hasMany(models.ProjectCustomer, {
      as: 'projectCustomers',
      foreignKey: 'customer_id',
      include: [{ model: models.Project, as: 'project', attributes: ['name'] }],
    });
  }

  static config(sequelize) {
    return {
      sequelize,
      tableName: CUSTOMER_TABLE,
      modelName: 'Customer',
      timestamps: false,
    };
  }

  static async getLastAddedClient() {
    try {
      const lastClient = await this.findOne({
        order: [['createdAt', 'DESC']], // Ordenar por fecha de creación descendente
      });
  
      return lastClient;
    } catch (error) {
      console.error('Error fetching last added project:', error);
      throw error;
    }
  }
}

module.exports = { CUSTOMER_TABLE, CustomerSchema, Customer };
