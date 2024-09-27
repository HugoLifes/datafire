const { models } = require('../lib/sequelize');
const boom = require('@hapi/boom');

class CalculosHugoService {
  async find() {
    const rta = await models.CalculosHugoService.findAll();
    return rta;
  }

  async findOne(id) {
    const calculo = await models.CalculosHugoService.findByPk(id);
    if (!calculo) {
      throw boom.notFound('Customer not found');
    }
    return calculo;
  }

  async create(data) {
    const newCalculo = await models.CalculosHugoService.create(data);
    return newCalculo;
  }

  async update(id, changes) {
    const calculo = await this.findOne(id);
    const rta = await calculo.update(changes);
    return rta;
  }

  async delete(id) {
    const calculo = await this.findOne(id);
    await calculo.destroy();
    return { id };
  }
}

module.exports = CalculosHugoService;
