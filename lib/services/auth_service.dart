class UserData {
  final String email;
  final String password;

  UserData({required this.email, required this.password});
}

class AuthService {
  static final List<UserData> users = [
    UserData(email: "user1@example.com", password: "password123"),
    UserData(email: "user2@example.com", password: "securepass"),
    UserData(email: "test@example.com", password: "testpass"),
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
    users.add(UserData(email: email, password: password));
    return true;
  }
}
