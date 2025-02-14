const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const route = require('./routes/index');
const mongoose = require('./configs/database');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(cookieParser());

app.use('/api', route);

module.exports = app;
