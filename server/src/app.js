const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const route = require('./routes/index');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(cookieParser());

app.use('/', route);

module.exports = app;
