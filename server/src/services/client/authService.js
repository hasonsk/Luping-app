const bcrypt = require('bcryptjs');
const User = require('../../models/client/User');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const accessKey = process.env.ACCESS_TOKEN_SALT;
const refreshKey = process.env.REFRESH_TOKEN_SALT;
const saltRounds = process.env.SALT_ROUNDS || 10;

class authService {
  static authenticateUser = async (email, password) => {
    try {
      const user = await User.findOne({ email });
      console.log(user);
      if (!user) {
        return { success: false, message: 'User not found' };
      }
      console.log('running');
      console.log(password + '   ------    ' + user.password);
      const isMatch = await bcrypt.compare(password, user.password);
      if (isMatch) {
        const accessToken = jwt.sign(
          { email: user.email, id: user.id },
          accessKey,
          {
            expiresIn: '30m',
          }
        );
        const refreshToken = jwt.sign(
          { email: user.email, id: user.id },
          refreshKey,
          {
            expiresIn: '30d',
          }
        );
        return {
          success: true,
          message: 'Login successfully',
          email: user.email,
          id : user.id,
          accessToken,
          refreshToken,
        };
      }
    } catch (err) {
      console.error(err);
      return { success: false, message: 'Internal server error' };
    }
  };

  static newUserSignUp = async (email, password, fullname) => {
    try {
      const checkIfEmailUsed = await User.findOne({ email });
      if (checkIfEmailUsed)
        return {
          success: false,
          message:
            'This Email has already been registered,please use another email address',
        };
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      console.log(
        'Creating new user:' + email + ' ' + hashedPassword + ' ' + fullname
      );
      const newUser = await User.create({
        email: email,
        password: hashedPassword,
        fullname: fullname,
      });
      console.log(newUser);
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
