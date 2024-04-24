const { Model, DataTypes, Sequelize } = require('sequelize');

const { WORKER_TABLE } = require('./trabajadores.model');

const TOOLS_TABLE = 'Tools';

const ToolsSchema = {
  id: {
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
    type: DataTypes.INTEGER,
  },
  worker_id: {
    field: 'worker_id',
    allowNull: false,
    type: DataTypes.INTEGER,
    references: {
      model: WORKER_TABLE,
      key: 'id',
    },
    onUpdate: 'CASCADE',
    onDelete: 'SET NULL',
  },
  tool_name: {
    allowNull: false,
    type: DataTypes.STRING,
  },
  cost: {
    allowNull: false,
    type: DataTypes.INTEGER,
  },
  fecha_adquisicion: {
    allowNull: true,
    type: DataTypes.DATE,
  },
  createdAt: {
    allowNull: false,
    type: DataTypes.DATE,
    field: 'create_at',
    defaultValue: Sequelize.NOW,
  },
};

class Tools extends Model {
  static associate(models) {
    this.belongsTo(models.Worker, {
      as: 'Worker',
      foreignKey: 'worker_id',
    });
  }

  static config(sequelize) {
    return {
      sequelize,
      tableName: TOOLS_TABLE,
      modelName: 'tools',
      timestamps: false,
      hooks: {
        afterCreate: async (workerCost, ) => {
          const worker = await this.sequelize.models.Worker.findByPk(
            workerCost.worker_id,
          );
          if (worker) {
            worker.WorkerCost += workerCost.cost;
            await worker.save();
          }
        },
        beforeDestroy: async (workerCost, ) => {
          const worker = await this.sequelize.models.Worker.findByPk(
            workerCost.worker_id,
          );
          if (worker) {
            worker.WorkerCost -= workerCost.cost;
            await worker.save();
          }
        },
        beforeUpdate: async (workerCost,) => {
          const worker = await this.sequelize.models.Worker.findByPk(
            workerCost.worker_id,
          );
          if (worker) {
            // Restar el coste antiguo y sumar el nuevo
            if (workerCost._previousDataValues.cost !== workerCost.cost) {
              worker.WorkerCost =
                worker.WorkerCost -
                workerCost._previousDataValues.cost +
                workerCost.cost;
              await worker.save();
            }
          }
        },
      },
    };
  }
}

module.exports = {
  TOOLS_TABLE,
  ToolsSchema,
  Tools,
};
