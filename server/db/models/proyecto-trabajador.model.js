const { Model, DataTypes, Sequelize } = require('sequelize');

const { PROJECT_TABLE } = require('./proyectos.model');
const { WORKER_TABLE } = require('./trabajadores.model');

const PROJECT_WORKER_TABLE = 'project_has_workers';

const ProjectWorkerSchema = {
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
  project_name: {
    type: DataTypes.STRING,
    allowNull: true,
    onUpdate: 'CASCADE',
    onDelete: 'SET NULL',
  },
  worker_name: {
    type: DataTypes.STRING,
    allowNull: true,
    onUpdate: 'CASCADE',
    onDelete: 'SET NULL',
  },
};

class ProjectWorker extends Model {
  static associate(models) {
    this.belongsTo(models.Project, {
      foreignKey: 'project_id',
      as: 'project',
      onDelete: 'SET NULL',
      onUpdate: 'CASCADE',
    });
    this.belongsTo(models.Worker, {
      foreignKey: 'worker_id',
      as: 'worker',
      onDelete: 'SET NULL',
      onUpdate: 'CASCADE',
    });
  }

  static config(sequelize) {
    return {
      sequelize,
      tableName: PROJECT_WORKER_TABLE,
      modelName: 'ProjectWorker',
      timestamps: false,
    };
  }
}

module.exports = {
  PROJECT_WORKER_TABLE,
  ProjectWorkerSchema,
  ProjectWorker,
};
