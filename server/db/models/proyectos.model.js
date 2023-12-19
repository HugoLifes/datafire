const {Model, DataTypes, Sequelize} = require("sequelize")

const {CUSTOMER_TABLE} = require("./cliente.model")

const PROJECT_TABLE = "proyectos"

const ProjectSchema = {
  id: {
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
    type: DataTypes.INTEGER
  },
  name:{
    allowNull: false,
    type: DataTypes.STRING
  },
  fecha_inicio: {
    allowNull: false,
    type: DataTypes.DATE
  },
  fecha_fin: {
    allowNull: false,
    type: DataTypes.DATE
  },
  costo:{
    allowNull: false,
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  customerId: {
    field: "customer_id",
    allowNull:false,
    type: DataTypes.INTEGER,
    references:{
      model: CUSTOMER_TABLE,
      key: "id"
    },
    onUpdate: "CASCADE",
    onDelete: "SET NULL",
    defaultValue: 0
  },
  createdAt: {
    allowNull: false,
    type: DataTypes.DATE,
    field: "create_at",
    defaultValue: Sequelize.NOW
  }
}

class Project extends Model {
  static associate(models) {
    this.hasMany(models.ProjectCustomer, {
      as: "projectCustomers",
      foreignKey: "project_id",
    });
    this.hasMany(models.Abonos, {
      as: "abonos",
      foreignKey: "projectId",
    });
  }


  static config(sequelize) {
    return {
      sequelize,
      tableName: PROJECT_TABLE,
      modelname: "project",
      timestamps: false
    }
  }
}

module.exports = {PROJECT_TABLE, ProjectSchema, Project}
