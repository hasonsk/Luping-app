const authService = require('../../services/client/authService');

class authController {
  static login = async (req, res) => {
    const { username, password } = req.body;
    try {
      const result = await authService.authenticateUser(username, password);

      if (!result.success)
        return res.status(401).json({ message: 'Authentication failed' });

      return res.status(200).json({ message: 'ok', token: result.token });
    } catch (err) {
      return res.status(500).json({ message: 'Internal server error' });
    }
  };

  static logout = (req, res) => {};

  static signup = async (req, res) => {
    const { username, password, email, fullname } = req.body;
    try {
      const result = await authService.newUserSignUp(
        username,
        password,
        email,
        fullname
      );
      if (result.success)
        return res.status(200).json({ message: result.message });
    } catch (err) {
      return res.status(500).json({ message: 'Internal server error' });
    }
  };

  static refreshAccessToken = async (req, res) => {
    try {
      const { refreshToken } = req.body.refToken;
      if (!refreshToken) {
        return res.status(403).json({ message: 'Refresh token required' });
      }
      const result = await authService.refreshToken(refreshToken);
      if (!result.success) res.status(401).json({ message: result.message });
      res.status(200).json({ token: result.accessToken });
    } catch (err) {
      res.status(500).json({ message: 'Internal server error' });
    }
  };
}
module.exports = authController;
