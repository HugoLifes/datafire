const { faker } = require('@faker-js/faker');
const boom = require("@hapi/boom")
const {create} = require("../schemas/trabajadores.schema")
const {models} = require("../lib/sequelize")

class WorkerService {

async find() {
  const rta = await models.Worker.findAll()
  return rta
}


  async findOne(id) {
    const worker = await models.Worker.findByPk(id)
    if (!worker) {
      throw boom.notFound("Worker not found")
    }
    return worker;
  }

  async create(data) {
    const newWorker = await models.Worker.create(data)
    return newWorker
  }

  async update(id, changes) {
    const worker = await this.findOne(id);

    if (!worker) {
      throw boom.notFound("Worker not found");
    }

    const rta = await worker.update(changes);
    return rta;
  }


  async delete(id){
    const worker = await this.findOne(id)

    await worker.destroy()
    return {id}
  }
}
module.exports = WorkerService;
