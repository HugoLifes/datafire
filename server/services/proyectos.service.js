const { faker } = require('@faker-js/faker');
const { models } = require('../lib/sequelize');
const boom = require('@hapi/boom');
const { addCustomerRESchema } = require('../schemas/proyectos.schema');

class ProjectService {
  constructor() {
    // this.projects = [], this.generate()
  }

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
        'abonos',
      ],
    });

    if (!project) {
      throw boom.notFound('Project not found');
    }

    return project;
  }

  async create(data) {
    const newProject = await models.Project.create(data);
    return newProject;
  }

  async findCustomerProject() {
    const rta = await models.ProjectCustomer.findAll();
    return rta;
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
  async update(id, changes) {
    const project = await this.findOne(id);

    const rta = await project.update(changes);
    return rta;
  }

  async delete(id) {
    const project = await this.findOne(id);

    await project.destroy();
    return { id };
  }
}

module.exports = ProjectService;
