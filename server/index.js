const express = require('express');

const routerApi = require('./routes');
const {logErrors, errorHandler, boomHandler, ormErrorHandler} = require("./middlewares/error.handler")

const app = express();
const port = 3001;

console.clear();

app.get('/', (req, res) => {
  res.send('Hello server');
});


app.use(express.json());

routerApi(app);

app.use(logErrors)
app.use(ormErrorHandler)
app.use(boomHandler)
app.use(errorHandler)

app.listen(port, () => {
  console.log('My port:' + port);
});
