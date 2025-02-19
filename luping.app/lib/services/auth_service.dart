import '../domain/models/user.dart';

class AuthService {
  static final List<User> users = [
    User(email: "user1@example.com", password: "password123"),
    User(email: "user2@example.com", password: "securepass"),
    User(email: "test@example.com", password: "testpass"),
  ];

  // Kiểm tra đăng nhập
  static bool authenticate(String email, String password) {
    return users.any((user) => user.email == email && user.password == password);
  }

  // Kiểm tra email đã tồn tại chưa
  static bool emailExists(String email) {
    return users.any((user) => user.email == email);
  }

  // Thêm người dùng mới
  static bool registerUser(String email, String password) {
    if (emailExists(email)) return false;
    users.add(User(email: email, password: password));
    return true;
  }
}
