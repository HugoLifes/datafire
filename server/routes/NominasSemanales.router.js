const express = require('express');
const router = express.Router();
const PDFDocument = require('pdfkit');
const { models } = require('../lib/sequelize');

const NominasSemanalesService = require('../services/NominasSemanales.service');
const service = new NominasSemanalesService();

const passport = require('passport');
const validatorHandler = require('../middlewares/validator.handler');
const { checkRoles } = require('../middlewares/auth.handler');
const {
  createWorkerSchema,
  getWorkerSchema,
  updateWorkerSchema,
} = require('../schemas/trabajadores.schema');


router.get('/generate-pdf', (req, res) => {
  // Crear un nuevo documento PDF
  const doc = new PDFDocument();

  // Establecer encabezados para descargar el PDF como un archivo
  res.setHeader('Content-Type', 'application/pdf');
  res.setHeader('Content-Disposition', 'attachment; filename=quote.pdf');

  // Enviar el documento PDF al cliente
  doc.pipe(res);

  // Agregar contenido al documento
  doc.fontSize(25).text('Esta es tu cotización!', 100, 100);

  // Finalizar el documento
  doc.end();
});


router.get('/', async (req, res, next) => {
  try {
    const workers = await service.find();
    res.json(workers);
  } catch (error) {
    next(error);
  }
});

router.get('/weeklyNominas', async (req, res, next) => {
  try {
    const workers = await service.findWeeklyNominasManual();
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
    const newPayroll = await service.create(body);
    res.status(201).json(newPayroll);
  } catch (error) {
    next(error);
  }
});

router.patch(
  '/:id',
  passport.authenticate('jwt', { session: false }),
  checkRoles('user', 'admin'),
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

module.exports = router;
