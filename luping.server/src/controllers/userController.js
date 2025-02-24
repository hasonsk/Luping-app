import * as userService from "../services/userService.js";
import multer from "multer";

const registerUser = async (req, res, next) => {
  try {
    const result = await userService.registerUser(req.body);
    res.status(201).json(result);
  } catch (error) {
    if (error instanceof multer.MulterError) {
      if (error.code === "LIMIT_FILE_SIZE") {
        return res
          .status(400)
          .json({ message: "File size exceeds the limit of 5MB." });
      }
      return res.status(400).json({ message: error.message });
    }
    next(error);
  }
};

const refreshToken = async (req, res, next) => {
  try {
    const result = await userService.refreshToken(req.body);
    res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

const loginUser = async (req, res, next) => {
  try {
    const result = await userService.loginUser(req.body);
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

const getUserProfile = async (req, res, next) => {
  try {
    const user = await userService.getUserProfile(req.user._id);
    res.status(200).json(user);
  } catch (error) {
    next(error);
  }
};

const updateUserProfile = async (req, res, next) => {
  try {
    const updatedUser = await userService.updateUserProfile(
      req.user._id,
      req.body,
    );
    res.status(200).json(updatedUser);
  } catch (error) {
    next(error);
  }
};

const changePassword = async (req, res, next) => {
  try {
    const { currentPassword, newPassword } = req.body;
    const result = await userService.changePassword(
      req.user._id,
      currentPassword,
      newPassword,
    );
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

const registerAdmin = async (req, res, next) => {
  try {
    const result = await userService.registerAdmin(req.body, req.mediaUrls);
    res.status(201).json(result);
  } catch (error) {
    if (error instanceof multer.MulterError) {
      if (error.code === "LIMIT_FILE_SIZE") {
        return res
          .status(400)
          .json({ message: "File size exceeds the limit of 5MB." });
      }
      return res.status(400).json({ message: error.message });
    }
    next(error);
  }
};

const getAllUsers = async (req, res, next) => {
  try {
    const result = await userService.getAllUsers(req.query);
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

const getProfileById = async (req, res, next) => {
  try {
    const profile = await userService.getProfileById(req.params.id);
    res.status(200).json(profile);
  } catch (error) {
    next(error);
  }
};

const sendCode = async (req, res, next) => {
  try {
    const result = await userService.sendCode(req.body.email);
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

const verifyCode = async (req, res, next) => {
  try {
    const { email, code } = req.body;
    const result = await userService.verifyCode(email, code);
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

export {
  registerUser,
  loginUser,
  getUserProfile,
  updateUserProfile,
  changePassword,
  registerAdmin,
  getAllUsers,
  getProfileById,
  sendCode,
  verifyCode,
  refreshToken,
};
