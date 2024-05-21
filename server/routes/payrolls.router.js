const express = require('express');
const router = express.Router();
const payrollService = require('../services/proyectos.service');
const service = new payrollService();
const validatorHandler = require('../middlewares/validator.handler');
const {
  getWorkerSchema,
  updateWorkerSchema,
} = require('../schemas/trabajadores.schema');


router.get('/', async (req, res, next) => {
  try {
    const workers = await service.findPayrolls();
    res.json(workers);
  } catch (error) {
    next(error);
  }
});

router.get('/payrollsWeek', async (req, res, next) => {
  try {
    const payrolls = await service.findPayrollsWeeks();
    res.json(payrolls);
  } catch (error) {
    next(error);
  }
});

router.get('/info', async (req, res, next) => {
  try {
    const payrolls = await service.getPayrollInformation();
    res.json(payrolls);
  } catch (error) {
    next(error);
  }
});

router.get(
  '/:id',
  validatorHandler(getWorkerSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const worker = await service.findOne(id);
      res.json(worker);
    } catch (error) {
      next(error);
    }
  },
);

router.post('/', async (req, res, next) => {
  try {
    const body = req.body;
    const newPayroll = await service.createPayroll(body);
    res.status(201).json(newPayroll);
  } catch (error) {
    next(error);
  }
});

router.patch(
  '/:id',
  validatorHandler(updateWorkerSchema, 'body'),
  validatorHandler(getWorkerSchema, 'params'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const { id } = req.params;
      const worker = await service.update(id, body);
      res.json(worker);
    } catch (error) {
      next(error);
    }
  },
);

router.delete(
  '/:id',
 
  validatorHandler(getWorkerSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      await service.delete(id);
      res.status(201).json({ id });
    } catch (error) {
      next(error);
    }
  },
);

module.exports = router;
