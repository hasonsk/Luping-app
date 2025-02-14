const bcrypt = require('bcryptjs');
const User = require('../../models/client/User');
const jwt = require('jsonwebtoken');
require('dotenv').config;

class authService {
  key = process.env.TOKEN_SALT;

  static authenticateUser = async (username, password) => {
    try {
      const user = await User.findOne({ username });
      if (!user) {
        return { success: false, message: 'User not found' };
      }

      const isMatch = bcrypt.compare(password, user.password);
      if (isMatch) {
        const token = jwt.sign({ username: user.username }, key, {
          expiresIn: '1d',
        });
        return { success: true, message: 'Login successfully', token: token };
      }
    } catch (err) {
      return { success: false, message: 'Internal server error' };
    }
  };

  static newUserSignUp = async (username, password, email, fullname) => {
    try {
      const checkIfUsernameExist = await User.findOne({ username });
      if (checkIfUsernameExist)
        return {
          success: false,
          message: 'User already exist,please choose another username',
        };
      const checkIfEmailUsed = await User.findOne({ email });
      if (checkIfEmailUsed)
        return {
          success: false,
          message:
            'This Email has already been registered,please use another email address',
        };
      const newUser = await User.create({
        username,
        password,
        email,
        fullname,
      });
      if (newUser) return { success: true, message: 'Signed up successfully' };
    } catch (err) {
      return { success: false, message: 'Internal server error' };
    }
  };
}

module.exports = authService;
