const { models } = require('../lib/sequelize');
const boom = require('@hapi/boom');

class AdjustmentsService {

  async findOne(id) {
    const calculo = await models.Adjustments.findByPk(id);
    if (!calculo) {
      throw boom.notFound('Customer not found');
    }
    return calculo;
  }

  async create(data) {
    const newCalculo = await models.Adjustments.create(data);
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

module.exports = AdjustmentsService;
