const express = require('express');
const router = express.Router();
const ProjectService = require('../services/proyectos.service');
const service = new ProjectService();

const validatorHandler = require('../middlewares/validator.handler');
const {
  createProjectsSchema,
  getProjectSchema,
  updateProjectSchema,
  addCustomerRESchema,
} = require('../schemas/proyectos.schema');

router.get('/', async (req, res, next) => {
  try {
    const projects = await service.find();
    res.json(projects);
  } catch (error) {
    next(error);
  }
});

router.get('/projectCustomer', async (req, res, next) => {
  try {
    const customerProject = await service.findCustomersProjects();
    res.json(customerProject);
  } catch (error) {
    next(error);
  }
});

router.get(
  '/projectCustomer/:id',
  validatorHandler(getProjectSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const projectCustomer = await service.findOneProjectCustomer(id);
      res.json(projectCustomer);
    } catch (error) {
      next(error);
    }
  },
);

router.get(
  '/:id',
  validatorHandler(getProjectSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const project = await service.findOne(id);
      res.json(project);
    } catch (error) {
      next(error);
    }
  },
);

router.post(
  '/',
  validatorHandler(createProjectsSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const newProject = service.create(body);
      res.status(201).json(newProject);
    } catch (error) {
      next(error);
    }
  },
);

router.post(
  '/projectCustomer',
  validatorHandler(addCustomerRESchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const newCustomer = await service.addCustomer(body);
      res.status(201).json(newCustomer);
    } catch (error) {
      next(error);
    }
  },
);

router.patch(
  '/:id',
  validatorHandler(getProjectSchema, 'params'),
  validatorHandler(updateProjectSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const { id } = req.params;
      const project = service.update(id, body);
      res.json(project);
    } catch (error) {
      next(error);
    }
  },
);

router.delete(
  '/:id',
  validatorHandler(getProjectSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      await service.deleteProject(id);
      res.status(201).json({ id });
    } catch (error) {
      next(error);
    }
  },
);
router.delete(
  '/projectCustomer/:id',
  validatorHandler(getProjectSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      await service.deleteProjectCustomer(id);
      res.status(201).json({ id });
    } catch (error) {
      next(error);
    }
  },
);

//------ProjectWorkers Router
router.get('/projectWorker', async (req, res, next) => {
  try {
    const projectWorker = await service.findProjectWorker();
    res.json(projectWorker);
  } catch (error) {
    next(error);
  }
});

router.get(
  '/projectWorker/:id',
  validatorHandler(getProjectSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const projectWorker = await service.findOneProjectWorker(id);
      res.json(projectWorker);
    } catch (error) {
      next(error);
    }
  },
);

module.exports = router;
