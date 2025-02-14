const route = require('express').Router();
const userAuthRoutes = require('./client/authRoutes');

route.use('/auth', userAuthRoutes);

module.exports = route;
