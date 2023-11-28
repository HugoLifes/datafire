const { faker } = require('@faker-js/faker');

class ProjectService {
  constructor() {
    (this.projects = []), this.generate();
  }

  generate() {
    const limit = 10;
    for (let index = 0; index < limit; index++) {
      const startDate = faker.date.past();
      const endDate = faker.date.between({
        from: startDate,
        to: faker.date.recent(),
      });
      this.projects.push({
        id: faker.string.uuid(),
        name: faker.company.name(),
        fecha_inicio: faker.date.past(),
        fecha_fin: endDate,
      });
    }
  }

  find() {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve(this.projects);
      }, 5000);
    });
  }

  findOne(id) {
    const project = this.projects.find((item) => item.id === id);
    return project;
  }

  create(data) {
    const newProject = {
      id: faker.string.uuid(),
      ...data,
    };
    this.projects.push(newProject);
    return newProject;
  }

  update(id, changes){
    const index = this.projects.findIndex(item => item.id = id)
    const project = this.projects[index]
    this.projects[index] = {
      ...project,
      ...changes
    }
    return this.projects[index]
  }

  delete(id){
    const index = this.projects.findIndex(item => item.id === id)
    this.projects.splice(index,1)
    return {id}
  }
}

module.exports = ProjectService;
