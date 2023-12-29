const { Model, Sequelize, DataTypes } = require('sequelize');

const WORKER_TABLE = 'trabajadores';

const WorkerSchema = {
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
  age: {
    allowNull: false,
    type: DataTypes.INTEGER,
  },
  position: {
    allowNull: false,
    type: DataTypes.STRING,
  },
  salary: {
    allowNull: false,
    type: DataTypes.INTEGER,
  },
  createdAt: {
    allowNull: false,
    type: DataTypes.DATE,
    field: 'create_at',
    defaultValue: Sequelize.NOW,
  },
};

class Worker extends Model {
  static static(models) {
    this.hasMany(models.ProjectWorker, {
      as: 'projectWorkers',
      foreignKey: 'worker_id',
      include: [{ model: models.Project, as: 'project', attributes: ['name'] }],
    });
  }

  static config(sequelize) {
    return {
      sequelize,
      tableName: WORKER_TABLE,
      modelname: 'worker',
      timestamps: false,
    };
  }
}

module.exports = { WORKER_TABLE, WorkerSchema, Worker };
