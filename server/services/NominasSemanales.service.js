const { faker } = require('@faker-js/faker');
const boom = require('@hapi/boom');
const { create } = require('../schemas/trabajadores.schema');
const { models } = require('../lib/sequelize');
const { Op } = require('sequelize');

class NominasSemanalesService {
  async find() {
    const rta = await models.NominasSemanales.findAll();
    return rta;
  }

  async findWeeklyNominasManual() {
    const startDate = new Date('2023-01-01'); // Fecha de inicio fija
    let endDate = new Date(); // Fecha actual como punto de partida para el cálculo del fin de semana
    endDate.setDate(endDate.getDate() + (14 - endDate.getDay())); // Extender al último día de la siguiente semana // Ajusta al último día de la semana actual (sábado, si domingo es el inicio de la semana)
    endDate.setHours(23, 59, 59, 999); // Asegura que el fin de semana abarque todo el día

    const nominas = await models.NominasSemanales.findAll({
      where: {
        fecha_inicio_semana: {
          [Op.gte]: startDate,
        },
        fecha_fin_semana: {
          [Op.lte]: endDate,
        },
      },
    });

    if (!nominas || nominas.length === 0) {
      throw new Error('Nominas not found');
    }

    const weeklyNominas = [];
    let currentDate = new Date(startDate);

    while (currentDate <= endDate) {
      const startOfWeek = new Date(currentDate);
      startOfWeek.setDate(startOfWeek.getDate() - startOfWeek.getDay());
      startOfWeek.setHours(0, 0, 0, 0);

      const endOfWeek = new Date(startOfWeek);
      endOfWeek.setDate(endOfWeek.getDate() + 6);
      endOfWeek.setHours(23, 59, 59, 999);

      // Filtrar y procesar las nóminas para esta semana específica
      const nominasForWeek = nominas
        .filter((nomina) => {
          const nominaStartDate = new Date(nomina.fecha_inicio_semana);
          return nominaStartDate >= startOfWeek && nominaStartDate <= endOfWeek;
        })
        .map((nomina) => ({
          workerId: nomina.worker_id,
          workerName: nomina.nombre,
          salary_hour: nomina.salary_hour,
          horas_trabajadas: nomina.horas_trabajadas,
          horas_extra: nomina.horas_extra,
          salary: nomina.salary,
          isr: nomina.isr,
          seguro_social: nomina.seguro_social,
          salary: nomina.salario_final,
          startDate: nomina.fecha_inicio_semana,
          endDate: nomina.fecha_fin_semana,
        }));

      const totalWeeklySalary = nominasForWeek.reduce(
        (total, nomina) => total + nomina.salary,
        0,
      );

      weeklyNominas.push({
        startDate: startOfWeek.toISOString(),
        endDate: endOfWeek.toISOString(),
        nominas: nominasForWeek,
        totalWeeklySalary,
      });

      currentDate.setDate(currentDate.getDate() + 7);
    }

    return weeklyNominas;
  }

  async findOne(id) {
    const worker = await models.Worker.findByPk(id);
    if (!worker) {
      throw boom.notFound('Worker not found');
    }
    return worker;
  }

  async create(data) {
    const newWorker = await models.NominasSemanales.create(data);
    return newWorker;
  }

  async update(id, changes) {
    const worker = await this.findOne(id);

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
}
module.exports = NominasSemanalesService;
