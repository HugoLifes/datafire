const Joi = require('joi');

const id = Joi.number().integer()
const name = Joi.string();
const last_name = Joi.string();
const company = Joi.string();

const createCustomersSchema = Joi.object({
  name: name.required(),
  last_name: last_name.required(),
  company: company.required(),
});

const updateCustomersSchema = Joi.object({
  name: name,
  last_name: last_name,
  company: company,
});

const getCustomersSchema = Joi.object({
  id: id
});

module.exports = {
  createCustomersSchema,
  updateCustomersSchema,
  getCustomersSchema,
};
