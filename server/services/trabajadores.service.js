
const boom = require('@hapi/boom');

const { models } = require('../lib/sequelize');

class WorkerService {
  async find() {
    const rta = await models.Worker.findAll();
    return rta;
  }

  async findTools() {
    const rta = await models.tools.findAll();
    return rta;
  }

  async findWorkerCost() {
    const rta = await models.WorkerCost.findAll();
    return rta;
  }
 

  async findOne(id) {
    const worker = await models.Worker.findByPk(id, {
      include: [{ model: models.WorkerCost, as: 'WorkerCosts' }],
    });
    if (!worker) {
      throw boom.notFound('Worker not found');
    }
    return worker;
  }

  async findOneTool(id) {
    const worker = await models.WorkerCost.findByPk(id);
    if (!worker) {
      throw boom.notFound('Worker not found');
    }
    return worker;
  }

  

  async create(data) {
    const newWorker = await models.Worker.create(data);
    return newWorker;
  }

  async createTools(data) {
    const newWorker = await models.WorkerCost.create(data);
    return newWorker;
  }

  async createTool(data) {
    const tool = await models.tools.create(data);
    return tool;
  }

  async update(id, changes) {
    const worker = await this.findOne(id);

    console.log(worker);

    if (!worker) {
      throw boom.notFound('Worker not found');
    }

    const rta = await worker.update(changes);
    return rta;
  }

  async delete(id) {
    const worker = await this.findOne(id);

    await worker.destroy();
    return { id };
  }

  async deleteProjectWorker(id) {
    const worker = await this.findOneTool(id);

    await worker.destroy();
    return { id };
  }

  async deleteTools(id) {
    const worker = await this.findOneTool(id);

    await worker.destroy();
    return { id };
  }
}
module.exports = WorkerService;
