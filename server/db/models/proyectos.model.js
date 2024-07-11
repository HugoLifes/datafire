const { Model, DataTypes, Sequelize } = require('sequelize');


const { CUSTOMER_TABLE } = require('./cliente.model');

const { Op } = require('sequelize');

const PROJECT_TABLE = 'proyectos';

const ProjectSchema = {
  id: {
    allowNull: false,
    autoIncrement: true,
    primaryKey: true,
    type: DataTypes.INTEGER,
  },
  name: {
    allowNull: false,
    type: DataTypes.STRING,
  },
  fecha_inicio: {
    allowNull: false,
    type: DataTypes.DATE,
  },
  fecha_fin: {
    allowNull: false,
    type: DataTypes.DATE,
  },
  duracion: {
    allowNull: false,
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },

  costo_inicial: {
    allowNull: false,
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  anticipo: {
    allowNull: false,
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  presupuesto: {
    allowNull: false,
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  costo: {
    allowNull: false,
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  abonado: {
    allowNull: false,
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  remaining: {
    allowNull: false,
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  ganancia: {
    allowNull: false,
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  status: {
    allowNull: false,
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  customerId: {
    field: 'customer_id',
    allowNull: false,
    type: DataTypes.INTEGER,
    references: {
      model: CUSTOMER_TABLE,
      key: 'id',
    },
    onUpdate: 'CASCADE',
    onDelete: 'SET NULL',
    defaultValue: 1,
  },
  createdAt: {
    allowNull: false,
    type: DataTypes.DATE,
    field: 'create_at',
    defaultValue: Sequelize.NOW,
  },
};

class Project extends Model {
  static associate(models) {
    this.hasMany(models.ProjectCustomer, {
      as: 'projectCustomers',
      foreignKey: 'project_id',
    });
    this.hasMany(models.Abonos, {
      as: 'abonos',
      foreignKey: 'projectId',
    });
    this.hasMany(models.ProjectWorker, {
      as: 'projectWorkers',
      foreignKey: 'project_id',
    });
    this.hasMany(models.Service, {
      as: 'services',
      foreignKey: 'project_id',
    });
    this.hasMany(models.Adjustments,{
      as: 'adjustments',
      foreignKey: 'projectId',
    });
    this.hasMany(models.NominasSemanales,{
      as: 'nominasSemanales',
      foreignKey: 'project_id'
    })
   
  }

  static config(sequelize) {
    return {
      sequelize,
      tableName: PROJECT_TABLE,
      modelname: 'project',
      timestamps: false,
      hooks: {
        beforeCreate: async (project, ) => {
          project.costo = project.costo_inicial;
          project.abonado = project.anticipo;

          const start = new Date(project.fecha_inicio);
          const end = new Date(project.fecha_fin);

          const durationInWeeks = Math.ceil(
            (end - start) / (7 * 24 * 60 * 60 * 1000),
          );
          project.duracion = durationInWeeks;
          project.ganancia = project.abonado - project.costo;
          project.remaining = project.presupuesto - project.abonado;
        },
        beforeUpdate: async (project, ) => {
          // Calcula la duración en semanas antes de la actualización
          const start = new Date(project.fecha_inicio);
          const end = new Date(project.fecha_fin);
          const durationInWeeks = Math.ceil(
            (end - start) / (7 * 24 * 60 * 60 * 1000),
          );
          project.duracion = durationInWeeks;
          project.ganancia = project.abonado - project.costo;
          project.remaining = project.presupuesto - project.abonado;
          
          // Verifica si 'remaining' se actualiza y es igual a 0
          if (project.changed('remaining') && project.remaining === 0) {
            // Cambia el valor de 'status' a true
            project.status = true;
          }

        },
        beforeDestroy: async (project,) => {
          await sequelize.models.Abonos.destroy({
            where: { proyecto_id: project.id },
          });
          await sequelize.models.ProjectWorker.destroy({
            where: { project_id: project.id },
          });
          await sequelize.models.Service.destroy({
            where: { project_id: project.id },
          });
          await sequelize.models.ProjectCustomer.destroy({
            where: { project_id: project.id },
          });

          await sequelize.models.Adjustments.destroy({
            where: { projectId: project.id },
          });

          await sequelize.models.NominasSemanales.destroy({
            where: { project_id: project.id },
          });
        

         
        },
      },
    };
  }

  static async getLastAddedProject() {
    try {
      const lastProject = await this.findOne({
        order: [['createdAt', 'DESC']], // Ordenar por fecha de creación descendente
      });
  
      return lastProject;
    } catch (error) {
      console.error('Error fetching last added project:', error);
      throw error;
    }
  }

  static async getLastPayment() {
    try {
      const lastPayment = await this.findOne({
        include: ['abonos'],
        order: [['fecha_inicio', 'DESC']], // Ordenar por fecha_inicio descendente
      });
  
      return lastPayment;
    } catch (error) {
      console.error('Error fetching last payment:', error);
      throw error;
    }
  }

  static async getTotalProjects() {
    try {
      const totalProjects = await this.count();
      return totalProjects;
    } catch (error) {
      console.error('Error fetching total projects:', error);
      throw error;
    }
  }

  static async getProjectsByMonth() {
    try {
      const currentDate = new Date();
      const twelveMonthsAgo = new Date(currentDate);
      twelveMonthsAgo.setMonth(currentDate.getMonth() - 12);

      const projectsByMonth = await this.findAll({
        attributes: [
          [
            Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
            'month',
          ],
          [Sequelize.fn('count', Sequelize.col('*')), 'projectCount'],
        ],
        where: {
          fecha_inicio: {
            [Op.between]: [twelveMonthsAgo, currentDate],
          },
        },
        group: [
          Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
        ],
        order: [
          Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
        ],
      });

      return projectsByMonth;
    } catch (error) {
      console.error('Error fetching projects by month:', error);
      throw error;
    }
  }

  static async getExpensesByMonth() {
    try {
      const currentDate = new Date();
      const twelveMonthsAgo = new Date(currentDate);
      twelveMonthsAgo.setMonth(currentDate.getMonth() - 12);

      const expensesByMonth = await this.findAll({
        attributes: [
          [
            Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
            'month',
          ],
          [Sequelize.fn('sum', Sequelize.col('costo')), 'totalExpense'],
        ],
        where: {
          fecha_inicio: {
            [Op.between]: [twelveMonthsAgo, currentDate],
          },
        },
        group: [
          Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
        ],
        order: [
          Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
        ],
      });

     

      return expensesByMonth;
    } catch (error) {
      console.error('Error fetching expenses by month:', error);
      throw error;
    }
  }
  static async getProfitByMonth() {
    try {
      const currentDate = new Date();
      const twelveMonthsAgo = new Date(currentDate);
      twelveMonthsAgo.setMonth(currentDate.getMonth() - 12);

      const profitByMonth = await this.findAll({
        attributes: [
          [
            Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
            'month',
          ],
          [Sequelize.fn('sum', Sequelize.col('ganancia')), 'totalProfit'],
        ],
        where: {
          fecha_inicio: {
            [Op.between]: [twelveMonthsAgo, currentDate],
          },
        },
        group: [
          Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
        ],
        order: [
          Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
        ],
      });

     

      return profitByMonth;
    } catch (error) {
      console.error('Error fetching profit by month:', error);
      throw error;
    }
  }

  static async getPaymentsByMonth() {
    try {
      const currentDate = new Date();
      const twelveMonthsAgo = new Date(currentDate);
      twelveMonthsAgo.setMonth(currentDate.getMonth() - 12);

      const paymentByMonth = await this.findAll({
        attributes: [
          [
            Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
            'month',
          ],
          [Sequelize.fn('sum', Sequelize.col('abonado')), 'totalPayment'],
        ],
        where: {
          fecha_inicio: {
            [Op.between]: [twelveMonthsAgo, currentDate],
          },
        },
        group: [
          Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
        ],
        order: [
          Sequelize.fn('date_trunc', 'month', Sequelize.col('fecha_inicio')),
        ],
      });

     

      return paymentByMonth;
    } catch (error) {
      console.error('Error fetching payments by month:', error);
      throw error;
    }
  }
  //datos a la semana
  static async getPaymentsByWeek() {
    try {
      const currentDate = new Date();
  
      // Calcula la fecha de inicio de la semana actual (considera el lunes como inicio)
      const currentWeekStart = new Date(currentDate);
      currentWeekStart.setDate(currentDate.getDate() - currentDate.getDay() + 1); // Lunes
  
      // Calcula la fecha de inicio de la semana hace 12 semanas
      const twelveWeeksAgo = new Date(currentWeekStart);
      twelveWeeksAgo.setDate(currentWeekStart.getDate() - 7 * 12); 
  
      const paymentByWeek = await this.findAll({
        attributes: [
          [
            Sequelize.fn('date_trunc', 'week', Sequelize.col('fecha_inicio')),
            'week',
          ],
          [Sequelize.fn('sum', Sequelize.col('abonado')), 'totalPayment'],
        ],
        where: {
          fecha_inicio: {
            [Op.between]: [twelveWeeksAgo, currentDate],
          },
        },
        group: [
          Sequelize.fn('date_trunc', 'week', Sequelize.col('fecha_inicio')),
        ],
        order: [
          Sequelize.fn('date_trunc', 'week', Sequelize.col('fecha_inicio')),
        ],
      });
  
      return paymentByWeek;
    } catch (error) {
      console.error('Error fetching payments by week:', error);
      throw error;
    }
  }
  static async getProfitByWeek() {
    try {
      const currentDate = new Date();
  
      // Calcula la fecha de inicio de la semana actual (considera el lunes como inicio)
      const currentWeekStart = new Date(currentDate);
      currentWeekStart.setDate(currentDate.getDate() - currentDate.getDay() + 1); // Lunes
  
      // Calcula la fecha de inicio de la semana hace 12 semanas
      const twelveWeeksAgo = new Date(currentWeekStart);
      twelveWeeksAgo.setDate(currentWeekStart.getDate() - 7 * 12); 
  
      const profitByWeek = await this.findAll({
        attributes: [
          [
            Sequelize.fn('date_trunc', 'week', Sequelize.col('fecha_inicio')),
            'week',
          ],
          [Sequelize.fn('sum', Sequelize.col('ganancia')), 'totalProfit'],
        ],
        where: {
          fecha_inicio: {
            [Op.between]: [twelveWeeksAgo, currentDate],
          },
        },
        group: [
          Sequelize.fn('date_trunc', 'week', Sequelize.col('fecha_inicio')),
        ],
        order: [
          Sequelize.fn('date_trunc', 'week', Sequelize.col('fecha_inicio')),
        ],
      });
  
      return profitByWeek;
    } catch (error) {
      console.error('Error fetching profit by week:', error);
      throw error;
    }
  }
  static async getExpensesByWeek() {
    try {
      const currentDate = new Date();
  
      // Calcula la fecha de inicio de la semana actual (considera el lunes como inicio)
      const currentWeekStart = new Date(currentDate);
      currentWeekStart.setDate(currentDate.getDate() - currentDate.getDay() + 1); // Lunes
  
      // Calcula la fecha de inicio de la semana hace 12 semanas
      const twelveWeeksAgo = new Date(currentWeekStart);
      twelveWeeksAgo.setDate(currentWeekStart.getDate() - 7 * 12); 
  
      const expensesByWeek = await this.findAll({
        attributes: [
          [
            Sequelize.fn('date_trunc', 'week', Sequelize.col('fecha_inicio')),
            'week',
          ],
          [Sequelize.fn('sum', Sequelize.col('costo')), 'totalExpense'],
        ],
        where: {
          fecha_inicio: {
            [Op.between]: [twelveWeeksAgo, currentDate],
          },
        },
        group: [
          Sequelize.fn('date_trunc', 'week', Sequelize.col('fecha_inicio')),
        ],
        order: [
          Sequelize.fn('date_trunc', 'week', Sequelize.col('fecha_inicio')),
        ],
      });
  
      return expensesByWeek;
    } catch (error) {
      console.error('Error fetching expenses by week:', error);
      throw error;
    }
  }

}

module.exports = { PROJECT_TABLE, ProjectSchema, Project };
