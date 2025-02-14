const mongoose = require('mongoose');
const { v4: uuidv4 } = require('uuid');
const userSchema = new mongoose.Schema(
  {
    _id: {
      type: String,
      default: uuidv4,
    },
    email: {
      type: String,
      required: true,
      maxlength: 50,
      unique: true,
    },
    password: {
      type: String,
      required: true,
      maxlength: 50,
    },
    fullname: {
      type: String,
      required: true,
      maxlength: 40,
    },
    avatar: {
      type: String,
      default: '',
    },
  },
  {
    timestamps: true,
    _id: false,
  }
);

const User = mongoose.model('User', userSchema);

module.exports = User;
