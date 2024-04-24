const Joi = require('joi');
const id = Joi.number().integer();
const name = Joi.string();
const last_name = Joi.string();
const age = Joi.number();
const position = Joi.string();
const salary = Joi.number().integer();
const salary_hour = Joi.number().integer();
const semanal_hours = Joi.number().integer();
const worker_id = Joi.number().integer();
const service = Joi.string();
const cost = Joi.number().integer();
const fecha_costo = Joi.date();

//tools
const tool_name = Joi.string();
const fecha_adquisicion = Joi.date();

const createWorkerSchema = Joi.object({
  name: name.required(),
  last_name: last_name.required(),
  age: age.required(),
  position: position.required(),
  semanal_hours: semanal_hours.required(),
  salary_hour: salary_hour.required(),
});

const createWorkerCostSchema = Joi.object({
  worker_id: worker_id,
  service: service,
  cost: cost,
  fecha_costo: fecha_costo,
});

const createToolSchema = Joi.object({
  worker_id: worker_id,
  tool_name: tool_name,
  cost: cost,
  fecha_adquisicion: fecha_adquisicion,
});

const updateWorkerSchema = Joi.object({
  name: name,
  last_name: last_name,
  age: age,
  position: position,
  salary: salary,
  salary_hour: salary_hour,
  semanal_hours: semanal_hours,
});

const updateSalaryWorkerSchema = Joi.object({
  name: name,
  last_name: last_name,
  age: age,
  position: position,
  salary: salary,
});

const getWorkerSchema = Joi.object({
  id: id.required(),
});

module.exports = {
  createWorkerSchema,
  createWorkerCostSchema,
  createToolSchema,
  updateSalaryWorkerSchema,
  updateWorkerSchema,
  getWorkerSchema,
};
