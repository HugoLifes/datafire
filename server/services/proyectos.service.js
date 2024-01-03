const { faker } = require('@faker-js/faker');
const { models } = require('../lib/sequelize');
const boom = require('@hapi/boom');
const {
  addCustomerRESchema,
  addWorkerRESchema,
  addServiceSchema,
} = require('../schemas/proyectos.schema');

class ProjectService {
  constructor() {
    // this.projects = [], this.generate()
  }
  // -------Project Services! -----
  async find() {
    const rta = await models.Project.findAll();
    return rta;
  }

  async findOne(id) {
    const project = await models.Project.findByPk(id, {
      include: [
        {
          model: models.ProjectCustomer,
          as: 'projectCustomers',
        },
        {
          model: models.ProjectWorker,
          as: 'projectWorkers',
        },
        'abonos',
        'services',
      ],
    });

    if (!project) {
      throw boom.notFound('Project not found');
    }

    return project;
  }

  async update(id, changes) {
    const project = await this.findOne(id);

    const rta = await project.update(changes);
    return rta;
  }

  async deleteProject(id) {
    const project = await this.findOne(id);

    await project.destroy();
    return { id };
  }

  async create(data) {
    const newProject = await models.Project.create(data);
    return newProject;
  }
  // ---------ProjectCustomers Service!-------
  async findCustomersProjects() {
    const rta = await models.ProjectCustomer.findAll();
    return rta;
  }

  async findOneProjectCustomer(id) {
    const projectCustomer = await models.ProjectCustomer.findByPk(id, {});

    if (!projectCustomer) {
      throw boom.notFound('ProjectCustomer not found');
    }

    return projectCustomer;
  }

  async addCustomer(data) {
    try {
      // Validar datos con Joi
      await addCustomerRESchema.validateAsync(data);

      // Obtener instancias de Project y Customer (puedes realizar consultas a la base de datos)
      const project = await models.Project.findByPk(data.project_id);
      const customer = await models.Customer.findByPk(data.customer_id);

      // Crear una nueva instancia de ProjectCustomer con las asociaciones
      const newCustomer = await models.ProjectCustomer.create({
        project_id: project.id,
        customer_id: customer.id,
        project_name: project.name,
        customer_name: `${customer.name} ${customer.last_name}`,
      });

      return newCustomer;
    } catch (error) {
      console.error('Error al agregar un cliente:', error);
      throw error;
    }
  }
  async deleteProjectCustomer(id) {
    const project = await this.findOneProjectCustomer(id);

    await project.destroy();
    return { id };
  }

  //----------ProjectWorkers Services!-----
  async findProjectsWorkers() {
    const rta = await models.ProjectWorker.findAll();
    return rta;
  }

  async findOneProjectWorker(id) {
    const projectWorker = await models.ProjectWorker.findByPk(id, {});

    if (!projectWorker) {
      throw boom.notFound('ProjectWorker not found');
    }
    return projectWorker;
  }

  async addProjectWorker(data) {
    try {
      await addWorkerRESchema.validateAsync(data);

      // Obtener instancias de Project y Worker
      const project = await models.Project.findByPk(data.project_id);
      const worker = await models.Worker.findByPk(data.worker_id);

      // Crear una nueva instancia de ProjectCustomer con las asociaciones
      const newWorker = await models.ProjectWorker.create({
        project_id: project.id,
        worker_id: worker.id,
        project_name: project.name,
        worker_name: `${worker.name} ${worker.last_name}`,
      });

      return newWorker;
    } catch (error) {
      console.error('Error al agregar un Trabajador:', error);
      throw error;
    }
  }
  async deleteProjectWorker(id) {
    const projectWorker = await this.findOneProjectWorker(id);
    await projectWorker.destroy();
    return { id };
  }

  //----------Costos Services!-----
  async findServices() {
    const rta = await models.Service.findAll();
    return rta;
  }

  async findOneService(id) {
    const service = await models.Service.findByPk(id, {});

    if (!service) {
      throw boom.notFound('Service not found');
    }
    return service;
  }

  async createService(data) {
    const newService = await models.Service.create(data);

    // Después de crear el servicio, actualiza el costo total del proyecto
    await this.updateProjectTotalCost(newService.project_id);

    return newService;
  }

  async deleteService(id) {
    const service = await this.findOneService(id);
    const projectId = service.project_id;

    // Antes de eliminar el servicio, obtén el costo del proyecto
    const project = await models.Project.findByPk(projectId);
    const initialProjectCost = project.costo;

    await service.destroy();

    // Después de eliminar el servicio, actualiza el costo total del proyecto
    await this.updateProjectTotalCost(projectId, initialProjectCost);

    return { id };
  }

  async updateProjectTotalCost(projectId) {
    const project = await models.Project.findByPk(projectId);

    if (project) {
      // Calcula la suma total de los costos de los servicios asociados al proyecto
      const totalCostOfServices = await models.Service.sum('cost', {
        where: { project_id: projectId },
      });

      // Si es el primer servicio, agrega el costo inicial del proyecto
      const totalCost = totalCostOfServices + project.costo;

      // Actualiza el costo total del proyecto
      await project.update({ costo: totalCost || 0 });
    }
  }
}

module.exports = ProjectService;
