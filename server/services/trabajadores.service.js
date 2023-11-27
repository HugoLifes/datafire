const { faker } = require('@faker-js/faker');

class WorkerService {
  constructor() {
    (this.workers = []), this.generate();
  }
  generate() {
    const limit = 10;
    for (let index = 0; index < 10; index++) {
      this.workers.push({
        id: faker.string.uuid(),
        name: faker.person.firstName(),
        last_name: faker.person.lastName(),
        age: faker.number.int({ min: 18, max: 100 }),
        position: faker.person.jobTitle(),
        salary: faker.finance.amount(100, 100000, 2),
      });
    }
  }
}
module.exports = WorkerService;