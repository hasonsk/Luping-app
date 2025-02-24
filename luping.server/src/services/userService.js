import jwt from "jsonwebtoken";
import crypto from "crypto";
import nodemailer from "nodemailer";
import User from "../models/User.js";
import {
  JWT_SECRET,
  JWT_EXPIRATION,
  JWT_REFRESH_EXPIRATION,
  MAIL_USER,
  mailConfig,
} from "../configs/config.js";

const generateToken = (id, role, type) => {
  return jwt.sign({ id, role }, JWT_SECRET, {
    expiresIn: type,
  });
};

const refreshToken = ({ token }) => {
  if (!token) throw { status: 404, detail: "Refresh token not found" };
  try {
    const data = jwt.verify(token, JWT_SECRET);
    const newAccessToken = generateToken(data._id, data.role, JWT_EXPIRATION);
    return {
      accessToken: newAccessToken,
    };
  } catch (err) {
    if (err.name === "TokenExpiredError") {
      err.status = 401;
      err.detail = "Your session has expired, please re-login again";
      throw err;
    } else {
      err.status = 403;
      err.detail = "Invalid token";
      throw err;
    }
  }
};

const registerUser = async (data) => {
  const { email, password, full_name, date_of_birth, phone_number } = data;

  const existingUser = await User.findOne({ email });
  if (existingUser) {
    const err = new Error("User with this email already exists.");
    err.status = 409;
    err.detail =
      "The provided email is already registered, please use another email.";
    throw err;
  }

  const profile = {
    full_name,
    date_of_birth,
    phone_number,
  };

  const user = new User({ email, password, profile });
  const savedUser = await user.save();
  const accessToken = generateToken(
    savedUser._id,
    savedUser.role,
    JWT_EXPIRATION,
  );
  const refreshToken = generateToken(
    savedUser._id,
    savedUser.role,
    JWT_REFRESH_EXPIRATION,
  );

  return {
    _id: savedUser._id,
    email: savedUser.email,
    role: savedUser.role,
    profile: savedUser.profile,
    accessToken,
    refreshToken,
  };
};

const loginUser = async ({ email, password }) => {
  const savedUser = await User.findOne({ email });
  if (!savedUser || !(await savedUser.matchPassword(password))) {
    const err = new Error("Invalid email or password.");
    err.status = 401;
    err.detail =
      "The provided email does not exist or the password is incorrect.";
    throw err;
  }
  const accessToken = generateToken(
    savedUser._id,
    savedUser.role,
    JWT_EXPIRATION,
  );
  const refreshToken = generateToken(
    savedUser._id,
    savedUser.role,
    JWT_REFRESH_EXPIRATION,
  );
  return {
    _id: savedUser._id,
    email: savedUser.email,
    role: savedUser.role,
    accessToken,
    refreshToken,
  };
};

const getUserProfile = async (userId) => {
  const user = await User.findById(userId)
    .select("-password")
    .populate("loved_restaurants", "name address");
  if (!user) {
    const err = new Error("User not found.");
    err.status = 404;
    err.detail = "The user with the provided ID does not exist.";
    throw err;
  }
  return user;
};

const updateUserProfile = async (userId, data) => {
  const { full_name, date_of_birth, phone_number } = data;

  const profileUpdates = {};
  if (full_name !== undefined) profileUpdates["profile.full_name"] = full_name;
  if (date_of_birth !== undefined)
    profileUpdates["profile.date_of_birth"] = date_of_birth;
  if (phone_number !== undefined)
    profileUpdates["profile.phone_number"] = phone_number;

  const updatedUser = await User.findByIdAndUpdate(
    userId,
    { $set: profileUpdates },
    { new: true, runValidators: true },
  ).select("-password");

  return updatedUser;
};

const changePassword = async (userId, currentPassword, newPassword) => {
  const user = await User.findById(userId);
  if (!user || !(await user.matchPassword(currentPassword))) {
    const err = new Error("Invalid current password.");
    err.status = 401;
    err.detail = "The provided current password is incorrect.";
    throw err;
  }
  user.password = newPassword;
  await user.save();
  return { message: "Password changed successfully." };
};

const registerAdmin = async (data) => {
  const { email, password, full_name, date_of_birth, phone_number } = data;

  const existingUser = await User.findOne({ $or: [{ email }] });
  if (existingUser) {
    const err = new Error("User with this email already exists.");
    err.status = 409;
    err.detail =
      "The provided email is already registered, please use another email.";
    throw err;
  }

  const profile = {
    full_name,
    date_of_birth,
    phone_number,
  };

  const admin = new User({ email, password, profile, role: "admin" });
  const savedAdmin = await admin.save();
  const accessToken = generateToken(
    savedAdmin._id,
    savedAdmin.role,
    JWT_EXPIRATION,
  );
  const refreshToken = generateToken(
    savedAdmin._id,
    savedAdmin.role,
    JWT_REFRESH_EXPIRATION,
  );

  return {
    _id: savedAdmin._id,
    email: savedAdmin.email,
    role: savedAdmin.role,
    profile: savedAdmin.profile,
    accessToken,
    refreshToken,
  };
};

const getAllUsers = async (queryParams) => {
  const {
    page = 1,
    limit = 10,
    search,
    role,
    banned,
    sortBy,
    sortOrder = "asc",
  } = queryParams;

  const query = {};
  if (search) {
    query.$or = [{ email: { $regex: search, $options: "i" } }];
  }
  if (role) query.role = role;
  if (banned !== undefined) query.banned = banned === "true";

  let sortOptions = {};
  if (sortBy) {
    sortOptions[sortBy] = sortOrder === "desc" ? -1 : 1;
  } else {
    sortOptions = { createdAt: -1 };
  }

  const users = await User.find(query)
    .select("-password -code -codeExpires")
    .sort(sortOptions)
    .skip((page - 1) * limit)
    .limit(parseInt(limit))
    .populate("name");

  const total = await User.countDocuments(query);

  return {
    total,
    page: parseInt(page),
    limit: parseInt(limit),
    totalPages: Math.ceil(total / limit),
    data: users,
  };
};

const getProfileById = async (id) => {
  const profile = await User.findById(id).select("profile");
  if (!profile) {
    const err = new Error("User not found.");
    err.status = 404;
    err.detail = "The user with the provided ID does not exist.";
    throw err;
  }
  return profile;
};

const sendCode = async (email) => {
  if (!email) {
    const err = new Error("Email is required");
    err.status = 400;
    err.detail =
      "Please provide the email address associated with your account.";
    throw err;
  }
  const user = await User.findOne({ email });
  if (!user) {
    const err = new Error("User not found");
    err.status = 404;
    err.detail = "The user with the provided email does not exist.";
    throw err;
  }

  const code = crypto.randomInt(100000, 999999).toString();
  user.code = code;
  user.codeExpires = Date.now() + 300000; // 5 minutes
  await user.save();

  const transporter = nodemailer.createTransport(mailConfig);
  const mailOptions = {
    from: `"Luping" <${MAIL_USER}>`,
    to: email,
    subject: "Password Reset Verification Code",
    html: `
            <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
                <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0;">
                    <h2 style="color: #4CAF50;">Password Reset Verification</h2>
                    <p>Dear ${user.profile.full_name},</p>
                    <p>We have received a request to reset your password. Please use the verification code below to proceed:</p>
                    <h3 style="color: #4CAF50;">${code}</h3>
                    <p>This code will expire in 5 minutes. If you did not request a password reset, please ignore this email.</p>
                    <hr style="border: none; border-top: 1px solid #e0e0e0;">
                    <p style="font-size: 12px; color: #777;">© ${new Date().getFullYear()} Luping. All rights reserved.</p>
                </div>
            </div>
        `,
  };

  await transporter.sendMail(mailOptions);
  return { message: "Code sent successfully" };
};

const verifyCode = async (email, code) => {
  if (!email || !code) {
    const err = new Error("Email and code are required");
    err.status = 400;
    err.detail = "Please provide the email address and verification code.";
    throw err;
  }
  const user = await User.findOne({ email });
  if (!user) {
    const err = new Error("User not found");
    err.status = 404;
    err.detail = "The user with the provided email does not exist.";
    throw err;
  }
  if (user.codeExpires < Date.now()) {
    const err = new Error("Code expired");
    err.status = 400;
    err.detail =
      "The verification code has expired. Please request a new code.";
    throw err;
  }
  if (user.code !== code) {
    const err = new Error("Invalid code");
    err.status = 400;
    err.detail = "The verification code is incorrect. Please try again.";
    throw err;
  }
  user.code = undefined;
  user.codeExpires = undefined;
  await user.save();
  return { message: "Code verified successfully" };
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
