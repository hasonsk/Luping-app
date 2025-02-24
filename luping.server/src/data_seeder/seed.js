const mongoose = require('mongoose');
const User = require('./path/to/your/UserModel'); // Đảm bảo cập nhật đường dẫn đúng

const sampleUsers = [
  {
    email: "user1@example.com",
    password: "password123",
    role: "user",
    profile: {
      full_name: "Nguyen Van A",
      date_of_birth: new Date("1990-01-01"),
      phone_number: "0123456789",
    },
    code: "abc123",
    codeExpires: new Date(Date.now() + 3600 * 1000), // Hết hạn sau 1 giờ
  },
  {
    email: "admin@example.com",
    password: "admin123",
    role: "admin",
    profile: {
      full_name: "Tran Thi B",
      date_of_birth: new Date("1985-05-15"),
      phone_number: "0987654321",
    },
    code: "def456",
    codeExpires: new Date(Date.now() + 3600 * 1000), // Hết hạn sau 1 giờ
  },
  {
    email: "user2@example.com",
    password: "mypassword",
    role: "user",
    profile: {
      full_name: "Le Van C",
      date_of_birth: new Date("1995-12-12"),
      phone_number: "0912345678",
    },
    code: "ghi789",
    codeExpires: new Date(Date.now() + 3600 * 1000), // Hết hạn sau 1 giờ
  },
];

async function seedDatabase() {
  await mongoose.connect('mongodb://localhost:27017/yourDatabaseName', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });

  try {
    // Xóa tất cả người dùng hiện tại
    await User.deleteMany({});
    // Thêm dữ liệu mẫu
    await User.insertMany(sampleUsers);
    console.log("Dữ liệu mẫu đã được thêm thành công!");
  } catch (error) {
    console.error("Lỗi khi thêm dữ liệu mẫu:", error);
  } finally {
    mongoose.connection.close();
  }
}

seedDatabase();
