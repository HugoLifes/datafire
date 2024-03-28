const { Client } = require('pg');

async function getConection() {
  const client = new Client({
    host: 'localhost',
    port: 5432,
    user: 'dani',
    password: 'daniadmin123',
    database: 'ultron',
  });
  await client.connect();
  return client;
}

module.exports = getConection;
