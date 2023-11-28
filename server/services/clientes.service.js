const { faker } = require('@faker-js/faker');

class CustomersService {
  constructor() {
    this.customers = [];
    this.generate();
  }

  generate() {
    const limit = 10;
    for (let index = 0; index < limit; index++) {
      this.customers.push({
        id: faker.string.uuid(),
        name: faker.person.firstName(),
        last_name: faker.person.lastName(),
        company: faker.company.name(),
      });
    }
  }

  findOne(id) {
    const customer = this.customers.find((item) => item.id === id);
    return customer;
  }

  create(data){
    const newCustomer = {
      id: faker.string.uuid(),
      ...data
    }
    this.customers.push(newCustomer)
    return newCustomer
  }

  update(id, changes) {
    const index = this.customers.findIndex(item => item.id === id);
    const customer = this.customers[index]
    this.customers[index] = {
      ...customer,
      ...changes
    }
    return this.customers[index]
  }
}

module.exports = CustomersService;
