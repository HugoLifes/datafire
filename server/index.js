const express = require('express');
const cors = require('cors');
const routerApi = require('./routes');

const {
  logErrors,
  errorHandler,
  boomHandler,
  ormErrorHandler,
} = require('./middlewares/error.handler');

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

console.clear();

const whitelist = ['http://localhost:8080', 'https://myapp.co'];
const options = {
  origin: (origin, callback) => {
    if (whitelist.includes(origin) || !origin) {
      callback(null, true);
    } else {
      callback(new Error('no permitido'));
    }
  },
};
app.use(cors(options));

app.get('/', (req, res) => {
  res.send('Hello server');
});

routerApi(app);

app.use(logErrors);
app.use(ormErrorHandler);
app.use(boomHandler);
app.use(errorHandler);

app.listen(port, () => {
  console.log('My port:' + port);
});
