const {Customer, CustomerSchema} = require("./cliente.model")
const {Project, ProjectSchema} = require("./proyectos.model")
const {Worker, WorkerSchema} = require("./trabajadores.model")

function setupModels(sequelize){
  Customer.init(CustomerSchema, Customer.config(sequelize)),
  Project.init(ProjectSchema, Project.config(sequelize)),
  Worker.init(WorkerSchema, Worker.config(sequelize))
}

module.exports = setupModels
