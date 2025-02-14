const authService = require('../../services/client/authService');

class authController {
  static login = async (req, res) => {
    const { username, password } = req.body;
    try {
      const result = await authService.authenticateUser(username, password);

      if (!result.success)
        return res.status(401).json({ message: 'Authentication failed' });

      res.status(200).json({ message: 'ok', token: result.token });
    } catch (err) {
      res.status(500).json({ message: 'Internal server error' });
    }
  };

  static logout = (req, res) => {
    res.cookie(null);
  };

  static signup = async (req, res) => {
    const { username, password, email, fullname } = req.body;
    const result = await authService.newUserSignUp(
      username,
      password,
      email,
      fullname
    );
  };
}
module.exports = authController;
