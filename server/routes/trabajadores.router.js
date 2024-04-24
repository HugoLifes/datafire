const express = require('express');
const router = express.Router();
const WorkerService = require('../services/trabajadores.service');
const service = new WorkerService();
const passport = require('passport');
const validatorHandler = require('../middlewares/validator.handler');
const { checkRoles } = require('../middlewares/auth.handler');
const {
  createWorkerSchema,
  getWorkerSchema,
  updateWorkerSchema,
  createWorkerCostSchema,
  updateSalaryWorkerSchema,
  createToolSchema,
} = require('../schemas/trabajadores.schema');

router.get('/', async (req, res, next) => {
  try {
    const workers = await service.find();
    res.json(workers);
  } catch (error) {
    next(error);
  }
});

router.get('/WorkerCosts', async (req, res, next) => {
  try {
    const workers = await service.findWorkerCost();
    res.json(workers);
  } catch (error) {
    next(error);
  }
});

router.get('/tools', async (req, res, next) => {
  try {
    const workers = await service.findTools();
    res.json(workers);
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


router.post(
  '/',
  validatorHandler(createWorkerSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const newWorker = await service.create(body);
      res.status(201).json(newWorker);
    } catch (error) {
      next(error);
    }
  },
);

router.post(
  '/WorkerCosts',

  validatorHandler(createWorkerCostSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const newWorker = await service.createWorkerCost(body);
      res.status(201).json(newWorker);
    } catch (error) {
      next(error);
    }
  },
);

router.post(
  '/tools',
  validatorHandler(createToolSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const newTool = await service.createTools(body);
      res.status(201).json(newTool);
    } catch (error) {
      next(error);
    }
  },
);

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
  passport.authenticate('jwt', { session: false }),
  checkRoles('user', 'admin'),
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

router.delete(
  '/WorkerCosts/:id',
  validatorHandler(getWorkerSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      await service.deleteProjectWorker(id);
      res.status(201).json({ id });
    } catch (error) {
      next(error);
    }
  },
);

router.delete(
  '/tools/:id',
  validatorHandler(getWorkerSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      await service.deleteTools(id);
      res.status(201).json({ id });
    } catch (error) {
      next(error);
    }
  },
);

router.patch(
  '/SalaryUpdate/:id',
  validatorHandler(updateSalaryWorkerSchema, 'body'),
  validatorHandler(getWorkerSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const newData = req.body;

      const salary = await service.update(id, newData);

      res.status(201).json(salary);
    } catch (err) {
      console.log(err);
      next(err);
    }
  },
);
module.exports = router;
