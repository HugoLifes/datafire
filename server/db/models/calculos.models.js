const { Model, DataTypes, Sequelize } = require('sequelize');

const { PROJECT_TABLE } = require('./proyectos.model');

const CalculosHugo_TABLE = 'CalculosHugo';

const CalculosHugoSchema = {
  id: {
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
    type: DataTypes.INTEGER,
  },
  amount: {
    allowNull: false,
    type: DataTypes.INTEGER,
  },
  service: {
    allowNull: false,
    type: DataTypes.STRING,
  },
  cost: {
    allowNull: false,
    type: DataTypes.INTEGER,
  },
  fecha_costo: {
    allowNull: true,
    type: DataTypes.DATE,
    default: '2019-01-12T08:28:24.762Z',
  },
  createdAt: {
    allowNull: false,
    type: DataTypes.DATE,
    field: 'create_at',
    defaultValue: Sequelize.NOW,
  },
};

class CalculosHugo extends Model {
  static associate(models) {

  }

  static config(sequelize) {
    return {
      sequelize,
      tableName: CalculosHugo_TABLE,
      modelName: 'Calculo',
      timestamps: false,
    };
  }
}

module.exports = {
  CalculosHugo_TABLE,
  CalculosHugoSchema,
  CalculosHugo,
};
