const { Model, DataTypes, Sequelize } = require('sequelize');
const { PROJECT_TABLE } = require('./proyectos.model');
const { CUSTOMER_TABLE } = require('./cliente.model');

const ADJUSTMENTS_TABLE = 'Adjustments';

const AdjustmentSchema = {
  id: {
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
    type: DataTypes.INTEGER,
  },
  monto: {
    allowNull: false,
    type: DataTypes.INTEGER,
  },
  fecha_ajuste: {
    allowNull: false,
    type: DataTypes.DATE,
  },
  projectId: {
    field: 'proyecto_id',
    allowNull: false,
    type: DataTypes.INTEGER,
    references: {
      model: PROJECT_TABLE,
      key: 'id',
    },
    onUpdate: 'CASCADE',
    onDelete: 'SET NULL',
    defaultValue: 0,
  },
  motive: {
    allowNull: true,
    type: DataTypes.STRING,
  },
  operation: {
    allowNull: false,
    type: DataTypes.BOOLEAN,
    default: false,
    //true sera suma al presupuesto
    //false sera resta al presupuesto
  },
  createdAt: {
    allowNull: false,
    type: DataTypes.DATE,
    field: 'create_at',
    defaultValue: Sequelize.NOW,
  },
};

class Adjustments extends Model {
  static associate(models) {
    this.belongsTo(models.Project, {
      as: 'project',
      foreignKey: 'projectId',
    });
  }

  static config(sequelize) {
    return {
      sequelize,
      tableName: ADJUSTMENTS_TABLE,
      modelName: 'Adjustments',
      timestamps: false,
      hooks: {
        afterCreate: async (adjustment, options) => {
          const project = await sequelize.models.Project.findByPk(
            adjustment.projectId,
          );
          if (project) {
            let newBudget = adjustment.operation
              ? project.presupuesto + adjustment.monto
              : project.presupuesto - adjustment.monto;
            await project.update({ presupuesto: newBudget });
          }
        },
      },
    };
  }
}

module.exports = {
  ADJUSTMENTS_TABLE,
  AdjustmentSchema,
  Adjustments,
};
