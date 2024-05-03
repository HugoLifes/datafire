const { Customer, CustomerSchema } = require('./cliente.model');
const { Project, ProjectSchema } = require('./proyectos.model');
const { Worker, WorkerSchema } = require('./trabajadores.model');
const { Service, ServiceSchema } = require('./servicios.model');
const { User, UserSchema } = require('./users.model');
const { Prestamo, PrestamoSchema } = require('./prestamos.model');
const { WorkerCost, WorkerCostsSchema } = require('./WorkerCosts.model');

const {
  ProjectCustomer,
  ProjectCustomerSchema,
} = require('./proyecto-cliente.model');
const {
  ProjectWorker,
  ProjectWorkerSchema,
} = require('./proyecto-trabajador.model');
const { Abonos, AbonosSchema } = require('./abonos.model');

//finances
const { Nomina, NominaSchema } = require('./nominas.model');

const {
  NominasSemanales,
  NominasSemanalesSchema,
} = require('./nominasSemanales');

const { CalculosHugo, CalculosHugoSchema } = require('./calculos.models');

const {
  Adjustments,
  AdjustmentSchema,
} = require('./adjustmentsProject.models');

const { Tools, ToolsSchema } = require('./tools.model');

function setupModels(sequelize) {
  Customer.init(CustomerSchema, Customer.config(sequelize));
  Project.init(ProjectSchema, Project.config(sequelize));
  Worker.init(WorkerSchema, Worker.config(sequelize));
  WorkerCost.init(WorkerCostsSchema, WorkerCost.config(sequelize));
  NominasSemanales.init(
    NominasSemanalesSchema,
    NominasSemanales.config(sequelize),
  );
  Service.init(ServiceSchema, Service.config(sequelize));
  Nomina.init(NominaSchema, Nomina.config(sequelize));
  ProjectWorker.init(ProjectWorkerSchema, ProjectWorker.config(sequelize));
  User.init(UserSchema, User.config(sequelize));
  ProjectCustomer.init(
    ProjectCustomerSchema,
    ProjectCustomer.config(sequelize),
  );
  Abonos.init(AbonosSchema, Abonos.config(sequelize));
  //finances
  Prestamo.init(PrestamoSchema, Prestamo.config(sequelize));
  CalculosHugo.init(CalculosHugoSchema, CalculosHugo.config(sequelize));

  Adjustments.init(AdjustmentSchema, Adjustments.config(sequelize));
  Tools.init(ToolsSchema, Tools.config(sequelize));

  Project.associate(sequelize.models);
  Abonos.associate(sequelize.models);
  Worker.associate(sequelize.models);
  WorkerCost.associate(sequelize.models);
}

module.exports = setupModels;
