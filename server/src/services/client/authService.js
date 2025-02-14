const bcrypt = require('bcryptjs');
const User = require('../../models/client/User');
const jwt = require('jsonwebtoken');
require('dotenv').config;

class authService {
  accessKey = process.env.ACCESS_TOKEN_SALT;
  refreshKey = process.env.REFRESH_TOKEN_SALT;
  saltRounds = process.env.SALT_ROUNDS || 10;
  static authenticateUser = async (username, password) => {
    try {
      const user = await User.findOne({ username });
      if (!user) {
        return { success: false, message: 'User not found' };
      }

      const isMatch = bcrypt.compare(password, user.password);
      if (isMatch) {
        const accessToken = jwt.sign(
          { username: user.username, id: user.id },
          accessKey,
          {
            expiresIn: '30m',
          }
        );
        const refreshToken = jwt.sign(
          { username: user.username, id: user.id },
          this.refreshToken,
          {
            expiresIn: '30d',
          }
        );
        return {
          success: true,
          message: 'Login successfully',
          accessToken,
          refreshToken,
        };
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
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      const newUser = await User.create({
        username,
        hashedPassword,
        email,
        fullname,
      });
      if (newUser) return { success: true, message: 'Signed up successfully' };
    } catch (err) {
      return { success: false, message: 'Internal server error' };
    }
  };

  static refreshToken = async (refreshToken) => {
    try {
      const { username, id } = jwt.verify(refreshToken, refreshKey);
      const accessToken = jwt.sign({ username, id }, accessKey, {
        expiresIn: '30m',
      });
      return { success: true, accessToken };
    } catch (err) {
      console.error('Token verification failed:', err.message);
      return {
        success: false,
        message: 'Your session has been expired, please re-login again.',
      };
    }
  };
}

module.exports = authService;
