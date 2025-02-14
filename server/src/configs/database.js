const mongoose = require('mongoose');
require('dotenv').config;

const dbURI = process.env.CLOUD_DB;

const option = {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  useCreateIndex: true,
  useFindAndModify: false,
  autoIndex: false, // Don't build indexes
  poolSize: 10, // Maintain up to 10 socket connections
  serverSelectionTimeoutMS: 5000, // Keep trying to send operations for 5 seconds
  socketTimeoutMS: 45000, // Close sockets after 45 seconds of inactivity
  family: 4, // Use IPv4, skip trying IPv6
};

mongoose
  .connect(dbURI, option)
  .then(() => {
    console.log('MongoDB is connected');
  })
  .catch((err) => {
    console.log('Connection lost,retry in 5 seconds');
    console.error('MongoDB connection error: ', err);
    setTimeout(connectWithRetry, 5000);
  });

function connectWithRetry() {
  mongoose.connect(dbURI, options);
}

mongoose.connection.on('connected', () => {
  console.log('Mongoose connected to ' + dbURI);
});

mongoose.connection.on('error', (err) => {
  console.log('Mongoose connection error: ' + err);
});

mongoose.connection.on('disconnected', () => {
  console.log('Mongoose disconnected');
});

process.on('SIGINT', () => {
  mongoose.connection.close(() => {
    console.log('Mongoose disconnected through app termination');
    process.exit(0);
  });
});


module.exports = mongoose;