const jwt = require('jsonwebtoken');
const accessKey = process.env.ACCESS_TOKEN_SALT;

exports.authenticate = (req, res, next) => {
  const authHeader = req.headers['Authorization'];
  if (!authHeader) {
    return res.status(401).json({ message: 'Authorization header is missing' });
  }
  const token = authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Token is missing' });
  }

  try {
    const decoded = jwt.verify(token, accessKey);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(403).json({ message: 'Invalid or expired token' });
  }
};
