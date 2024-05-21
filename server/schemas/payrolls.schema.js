const Joi = require('joi');

const id = Joi.number().integer();
const project_id = Joi.number().integer();
const worker_id = Joi.number().integer();
const amount_paid = Joi.number().integer();
const weeks_worked = Joi.number().integer();
const payment_dates = Joi.date();

const createPayrollrSchema = Joi.object({
  project_id: project_id.required(),
  worker_id: worker_id.required(),
  amount_paid: amount_paid.required(),
  weeks_worked: weeks_worked.required(),
  payment_dates: payment_dates.required(),
});


module.exports = {
  createPayrollrSchema,
  
};
