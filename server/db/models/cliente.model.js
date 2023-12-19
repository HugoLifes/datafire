const {Model, DataTypes, Sequelize} = require("sequelize")

const CUSTOMER_TABLE = "clientes"

const CustomerSchema = {
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
  last_name:{
    allowNull: false,
    type: DataTypes.STRING
  },
  company: {
    allowNull: false,
    type: DataTypes.STRING
  },
  createdAt: {
    allowNull: false,
    type: DataTypes.DATE,
    field: "create_at",
    defaultValue: Sequelize.NOW
  }
}

class Customer extends Model {
  static associate(models) {
    this.hasMany(models.Project, {
      as: "projects",
      foreignKey: "projectId"
    });
  }


  static config(sequelize){
    return{
      sequelize,
      tableName: CUSTOMER_TABLE,
      modelName: "Customer",
      timestamps: false
    }
  }
}

module.exports = {CUSTOMER_TABLE, CustomerSchema, Customer}
