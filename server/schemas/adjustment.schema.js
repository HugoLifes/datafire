const Joi = require('joi');

const id = Joi.number().integer();
const name = Joi.string();
const email = Joi.string().email();
const password = Joi.string().min(8);
const role = Joi.string().min(4);

const monto = Joi.number().integer();
const fecha_ajuste = Joi.date();
const projectId = Joi.number().integer();
const motive = Joi.string();
const operation = Joi.boolean();

const createAdjustmentSchema = Joi.object({
  monto: monto.required(),
  fecha_ajuste: fecha_ajuste.required(),
  projectId: projectId.required(),
  motive: motive.required(),
  operation: operation.required(),
});

const updateUserSchema = Joi.object({
  name: name,
  email: email,
  role: role,
});

const getUserSchema = Joi.object({
  id: id.required(),
});

module.exports = {
  createAdjustmentSchema,
  updateUserSchema,
  getUserSchema,
};
