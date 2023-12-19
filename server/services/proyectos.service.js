const { faker } = require('@faker-js/faker');
const {models} = require("../lib/sequelize")
const boom = require("@hapi/boom")

class ProjectService {
  constructor() {
    // this.projects = [], this.generate()
  }

  async find() {
    const rta = await models.Project.findAll()
    return rta
  }

  async findOne(id) {
    const project = await models.Project.findByPk(id,{
      include: [
        {association:"customer"},
      "customer",
      "abonos"
    ]
})

    if (!project) {
      throw boom.notFound("Project not found")
    }
    return project
  }

  async create(data) {
    const newProject = await models.Project.create(data)
    return newProject
  }

  async addCustomer(data) {
    const newCustomer = await models.ProjectCustomer.create(data)
    return newCustomer
  }

  async update(id, changes){
    const project = await this.findOne(id)

    const rta = await project.update(changes)
    return rta
  }

  async delete(id){
    const project = await this.findOne(id)

    await project.destroy()
    return {id}
}
}

module.exports = ProjectService;
