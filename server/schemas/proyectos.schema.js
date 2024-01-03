const Joi = require('joi');

const id = Joi.number().integer();
const name = Joi.string();
fecha_inicio = Joi.date();
fecha_fin = Joi.date();
costo = Joi.number().integer();
const project_id = Joi.number().integer();
const customer_id = Joi.number().integer();
const worker_id = Joi.number().integer();
const cost = Joi.number().integer();
const amount = Joi.number().integer();
const service = Joi.string();

const createProjectsSchema = Joi.object({
  name: name.required(),
  fecha_inicio: fecha_inicio.required(),
  fecha_fin: fecha_fin.required(),
  costo: costo.required(),
});

const updateProjectSchema = Joi.object({
  id: id,
  name: name,
  fecha_inicio: fecha_inicio,
  fecha_fin: fecha_fin,
  costo: costo,
  customer_id: customer_id,
});

const getProjectSchema = Joi.object({
  id: id.required(),
});
// ----projectCustomer Schemas----
const addCustomerRESchema = Joi.object({
  project_id: project_id.required(),
  customer_id: customer_id.required(),
});
// ====ProjectWorker Schemas----
const addWorkerRESchema = Joi.object({
  project_id: project_id.required(),
  worker_id: worker_id.required(),
});
// ====Servie Schemas----
const addServiceSchema = Joi.object({
  project_id: project_id.required(),
  amount: amount.required(),
  service: service.required(),
  cost: cost.required(),
});

module.exports = {
  createProjectsSchema,
  updateProjectSchema,
  getProjectSchema,
  addCustomerRESchema,
  addWorkerRESchema,
  addServiceSchema,
};
