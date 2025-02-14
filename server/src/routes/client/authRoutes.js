const express = require('express');
const router = express.Router();
const authController = require('../../controllers/client/authController');

router.post('/login', authController.login);
router.post('/sign-up', authController.signup);
router.get('/log-out', authController.logout);
router.post('/refresh-token', authController.refreshAccessToken);
module.exports = router;
