const express = require('express');
const router = express.Router();
const CalculosHugoService = require('../services/proyectos.service');
const service = new CalculosHugoService();



const validatorHandler = require('../middlewares/validator.handler');
const {
  getCustomersSchema,
  updateCustomersSchema,
} = require('../schemas/clientes.schema');
const { createAdjustmentSchema } = require('../schemas/adjustment.schema');



router.get('/', async (req, res, next) => {
  try {
    const customers = await service.findAdustments();
    res.json(customers);
  } catch (error) {
    next(error);
  }
});

router.get(
  '/:id',
  validatorHandler(getCustomersSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const customer = await service.findOneAdjustment(id);
      res.json(customer);
    } catch (error) {
      next(error);
    }
  },
);

router.post(
  '/',
  validatorHandler(createAdjustmentSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const newCustomer = await service.createAdjustment(body);

      res.status(201).json(newCustomer);
    } catch (error) {
      next(error);
    }
  },
);

router.patch(
  '/:id',
  validatorHandler(getCustomersSchema, 'params'),
  validatorHandler(updateCustomersSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const { id } = req.params;
      const customer = await service.updateAdjustment(id, body);
      res.json(customer);
    } catch (error) {
      next(error);
    }
  },
);

router.delete(
  '/:id',
  validatorHandler(getCustomersSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      await service.deleteAdjustment(id);
      res.status(201).json({ id });
    } catch (error) {
      next(error);
    }
  },
);

module.exports = router;
