const express = require('express');
const router = express.Router();
const ProjectService = require('../services/proyectos.service');
const service = new ProjectService();
const { models } = require('../lib/sequelize');
const PDFDocument = require('pdfkit');
const passport = require('passport');
const { checkRoles } = require('../middlewares/auth.handler');
const { format } = require('date-fns');

const validatorHandler = require('../middlewares/validator.handler');
const {
  createProjectsSchema,
  getProjectSchema,
  updateProjectSchema,
  addCustomerRESchema,
  addWorkerRESchema,
  addServiceSchema,
  getCostSchema,
  updateCostsSchema,
  addAbonoSchema,
  getAbonoSchema,
  updateAbonoSchema,
} = require('../schemas/proyectos.schema');


router.get('/', async (req, res, next) => {
  try {
    const projects = await service.findProjects();
    res.json(projects);
  } catch (error) {
    next(error);
  }
});

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

  doc.end();
});

router.get('/:id/pdf', async (req, res, next) => {
  try {
    const { id } = req.params;
    const project = await service.findOne(id);

    const doc = new PDFDocument();
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader(
      'Content-Disposition',
      `attachment; filename="${project.name}.pdf"`,
    );

    doc.pipe(res);

    doc.fillColor('#000'); // Establece el color del texto a negro para la sección inicial
    doc.fontSize(25).text(`Proyecto: ${project.name}`, { underline: true });
    doc.fontSize(12).moveDown();
    doc.text(
      `Fecha de Inicio: ${format(
        new Date(project.fecha_inicio),
        'dd/MM/yyyy',
      )}`,
    );
    doc.text(
      `Fecha de Fin: ${format(new Date(project.fecha_fin), 'dd/MM/yyyy')}`,
    );
    doc.text(`Duración: ${project.duracion} días`);
    doc.text(`Costo Inicial: $${project.costo_inicial}`);
    doc.text(`Costo Total: $${project.costo}`);
    doc.text(`Total Abonado: $${project.abonado}`);
    doc.text(`Pendiente: $${project.remaining}`);
    doc.moveDown(2);

    // Abonos
    doc.fontSize(18).text('Abonos', { underline: true });
    doc.fontSize(10).moveDown();
    drawTable(
      doc,
      project.abonos,
      ['Fecha', 'Monto'],
      (item) => [
        format(new Date(item.fecha_abono), 'dd/MM/yyyy'),
        `$${item.monto}`,
      ],
      {
        totalLabel: 'Total Abonado',
        totalValue: project.abonado,
      },
    );

    doc.moveDown(2);

    doc.fillColor('#000');
    doc.fontSize(18).text('Costos', { underline: true });
    doc.fontSize(4).moveDown();
    drawTable(
      doc,
      project.services,
      ['Fecha', 'Servicio', 'Costo'],
      (item) => [
        format(new Date(item.fecha_costo), 'dd/MM/yyyy'),
        `${item.service}`,
        `$${item.cost}`,
      ],
      {
        totalLabel: 'Total ',
        totalValue: project.costo,
      },
    );

    doc.end();
  } catch (error) {
    next(error);
  }
});

function drawTable(doc, data, headers, rowMapper, options = {}) {
  let tableTop = doc.y;
  let colWidths = [100, 280, 100];
  doc.fontSize(10);

  // Cabecera
  doc.fillColor('#444');
  doc.rect(50, tableTop, sum(colWidths, 0, colWidths.length), 20).fill();
  doc.fillColor('#fff');
  headers.forEach((header, i) => {
    doc.text(header, 50 + sum(colWidths, 0, i), tableTop + 6, {
      width: colWidths[i],
      align: 'center',
    });
  });

  // Filas
  tableTop += 20;
  doc.fillColor('#000');
  data.forEach((item, index) => {
    const row = rowMapper(item);
    row.forEach((text, i) => {
      doc.text(text, 50 + sum(colWidths, 0, i), tableTop + index * 20 + 6, {
        width: colWidths[i],
        align: 'center',
      });
    });
  });

  // Total
  if (options.totalLabel && options.totalValue) {
    doc.fillColor('#000');
    doc
      .rect(
        50,
        tableTop + data.length * 20 + 6,
        sum(colWidths, 0, colWidths.length),
        20,
      )
      .fill();
    doc.fillColor('#fff');
    doc.text(options.totalLabel, 50, tableTop + data.length * 20 + 12, {
      width: colWidths[0],
      align: 'center',
    });
    doc.text(
      `$${options.totalValue}`,
      50 + sum(colWidths, 0, colWidths.length - 1),
      tableTop + data.length * 20 + 12,
      { width: colWidths[colWidths.length - 1], align: 'center' },
    );
  }
}

function sum(arr, start, end) {
  let total = 0;
  for (let i = start; i < end; i++) {
    total += arr[i];
  }
  return total;
}

router.get('/projectCustomer', async (req, res, next) => {
  try {
    const customerProject = await service.findCustomersProjects();
    res.json(customerProject);
  } catch (error) {
    next(error);
  }
});

router.get('/projectWorker', async (req, res, next) => {
  try {
    const projectWorkers = await service.findProjectsWorkers();
    res.json(projectWorkers);
  } catch (error) {
    next(error);
  }
});

router.get('/services', async (req, res, next) => {
  try {
    const services = await service.findServices();
    res.json(services);
  } catch (error) {
    next(error);
  }
});

router.get('/abonos', async (req, res, next) => {
  try {
    const abonos = await service.findAbonos();
    res.json(abonos);
  } catch (error) {
    next(error);
  }
});

router.get('/cuentasCobrar', async (req, res, next) => {
  try {
    const projects = await models.Project.findAll({
      where: {
        status: false,
      },
      include: [
        {
          model: models.ProjectCustomer,
          as: 'projectCustomers',
          attributes: ['customer_name'],
        },
      ],
      attributes: ['name', 'remaining'],
    });

    res.json(projects);
  } catch (error) {
    next(error);
  }
});

router.get('/project-stats', async (req, res) => {
  try {
    const totalProjects = await models.Project.getTotalProjects();
    const projectsByMonth = await models.Project.getProjectsByMonth();
    const CostsByMonth = await models.Project.getExpensesByMonth();

    res.json({ totalProjects, projectsByMonth, CostsByMonth });
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
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

router.get('/egresos', async (req, res, next) => {
  try {
    const weeklyCosts = await service.findWeeklyCosts();
    res.json(weeklyCosts);
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
    next(error);
  }
});

router.get('/prestamos', async (req, res, next) => {
  try {
    const weeklyCosts = await service.findAllPrestamos();
    res.json(weeklyCosts);
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
    next(error);
  }
});

router.post('/prestamos', async (req, res, next) => {
  try {
    const nuevoPrestamo = await service.createPrestamo(req.body);
    res.status(201).json(nuevoPrestamo);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
    next(error);
  }
});

router.get('/flujo', async (req, res, next) => {
  try {
    const startDate = new Date('2023-01-01');
    const endDate = new Date();

    const projects = await models.Project.findAll({
      include: ['abonos', 'services'],
    });

    if (!projects || projects.length === 0) {
      return res.status(404).json({ error: 'Projects not found' });
    }

    const prestamos = await service.findAllPrestamos();

    const weeklyFlows = [];

    let currentDate = new Date(startDate);

    while (currentDate <= endDate) {
      const startOfWeek = new Date(currentDate);
      startOfWeek.setHours(0, 0, 0, 0);
      const endOfWeek = new Date(currentDate);
      endOfWeek.setDate(endOfWeek.getDate() + 6);
      endOfWeek.setHours(23, 59, 59, 999);

      // Obtener el balance total de la semana pasada
      const lastWeekBalance =
        weeklyFlows.length > 0
          ? weeklyFlows[weeklyFlows.length - 1]['Balance total']
          : 0;

      // Lógica de cálculo de ingresos semanales
      // Lógica de cálculo de ingresos semanales
      const weeklyIncomes = projects.reduce((total, project) => {
        const projectData = project.toJSON();
        const projectWeeklyIncome = projectData.abonos.reduce(
          (totalAbono, abono) => {
            const abonoDate = new Date(abono.createdAt);
            return abonoDate >= startOfWeek && abonoDate <= endOfWeek
              ? totalAbono + abono.monto
              : totalAbono;
          },
          0,
        );

        // Agregar ingresos semanales de abonos al total
        const abonosForWeek = projectData.abonos.filter((abono) => {
          const abonoDate = new Date(abono.createdAt);
          return abonoDate >= startOfWeek && abonoDate <= endOfWeek;
        });

        const abonosTotalForWeek = abonosForWeek.reduce(
          (totalAbono, abono) => totalAbono + abono.monto,
          0,
        );

        return total + abonosTotalForWeek;
      }, 0);

      // Lógica de cálculo de egresos semanales
      const weeklyExpenses = projects.reduce((total, project) => {
        const projectData = project.toJSON();
        const projectWeeklyExpense = projectData.services.reduce(
          (totalService, service) => {
            const serviceDate = new Date(service.createdAt);
            return serviceDate >= startOfWeek && serviceDate <= endOfWeek
              ? totalService + service.cost
              : totalService;
          },
          0,
        );
        return total + projectWeeklyExpense;
      }, 0);

      // Lógica de cálculo de préstamos semanales
      const weeklyPrestamo = prestamos.reduce((totalPrestamo, prestamo) => {
        const prestamoDate = new Date(prestamo.date_prestamo);
        return prestamoDate >= startOfWeek && prestamoDate <= endOfWeek
          ? totalPrestamo + prestamo.amount_paid
          : totalPrestamo;
      }, 0);

      // Resto de la lógica para calcular caja, balance de flujo, etc.

      // Crear el objeto de flujo semanal
      const weeklyFlow = {
        startDate: startOfWeek.toISOString(),
        endDate: endOfWeek.toISOString(),
        caja: lastWeekBalance,
        ingresos: weeklyIncomes,
        egresos: weeklyExpenses,
        'balance de flujo': lastWeekBalance + weeklyIncomes - weeklyExpenses,
        prestamo: weeklyPrestamo,
        'Balance total':
          lastWeekBalance + weeklyIncomes - weeklyExpenses + weeklyPrestamo,
      };

      // Agregar el flujo semanal al array
      weeklyFlows.push(weeklyFlow);

      // Mover a la siguiente semana
      currentDate.setDate(currentDate.getDate() + 7);
    }

    // Enviar la respuesta con los flujos semanales
    res.json(weeklyFlows);
  } catch (error) {
    // Manejar cualquier error que pueda ocurrir
    next(error);
  }
});

router.get('/ingresos', async (req, res, next) => {
  try {
    const services = await service.findWeeklyAbonos();
    res.json(services);
  } catch (error) {
    next(error);
  }
});

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
      const newCustomer = await service.addProjectCustomer(body);
      res.status(201).json(newCustomer);
    } catch (error) {
      next(error);
    }
  },
);

router.patch(
  '/:id',
  passport.authenticate('jwt', { session: false }),
  checkRoles('user', 'admin'),
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

/**---------------------------------------ProjectWorkers--------------------------------------------------------- */
// puse el get all arriba por que estaba teniendo problemas de asincronismo
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

router.post(
  '/projectWorker',
  validatorHandler(addWorkerRESchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const newCustomer = await service.addProjectWorker(body);
      res.status(201).json(newCustomer);
    } catch (error) {
      next(error);
    }
  },
);

router.delete(
  '/projectWorker/:id',
  validatorHandler(getProjectSchema, 'params'),
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

/**---------------------------------------Services Router--------------------------------------------------------- */
// puse el get all arriba por que estaba teniendo problemas de asincronismo
router.get(
  '/services/:id',
  validatorHandler(getProjectSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const projectWorker = await service.findOneService(id);
      res.json(projectWorker);
    } catch (error) {
      next(error);
    }
  },
);

router.post(
  '/services',
  validatorHandler(addServiceSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const newService = await service.createService(body);
      res.status(201).json(newService);
    } catch (error) {
      next(error);
    }
  },
);

router.patch(
  '/services/:id',
  passport.authenticate('jwt', { session: false }),
  checkRoles('user', 'admin'),
  validatorHandler(getCostSchema, 'params'),
  validatorHandler(updateCostsSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const { id } = req.params;
      const cost = service.updateCost(id, body);
      res.json(cost);
    } catch (error) {
      next(error);
    }
  },
);

router.delete(
  '/services/:id',
  validatorHandler(getProjectSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      await service.deleteService(id);
      res.status(201).json({ id });
    } catch (error) {
      next(error);
    }
  },
);

/**--------------------Abonos router---------------------------------------------------------------------------- */
router.get(
  '/abonos/:id',
  validatorHandler(getProjectSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const abono = await service.findOneAbono(id);
      res.json(abono);
    } catch (error) {
      next(error);
    }
  },
);

router.post(
  '/abonos',
  validatorHandler(addAbonoSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const abono = await service.createAbono(body);
      res.status(201).json(abono);
    } catch (error) {
      next(error);
    }
  },
);

router.patch(
  '/abonos/:id',
  validatorHandler(getAbonoSchema, 'params'),
  validatorHandler(updateAbonoSchema, 'body'),
  async (req, res, next) => {
    try {
      const body = req.body;
      const { id } = req.params;
      const cost = service.updateAbono(id, body);
      res.json(cost);
    } catch (error) {
      next(error);
    }
  },
);

router.delete(
  '/abonos/:id',
  validatorHandler(getAbonoSchema, 'params'),
  async (req, res, next) => {
    try {
      const { id } = req.params;
      await service.deleteAbono(id);
      res.status(201).json({ id });
    } catch (error) {
      next(error);
    }
  },
);

module.exports = router;
