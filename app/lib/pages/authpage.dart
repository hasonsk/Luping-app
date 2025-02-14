import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  final bool initialMode; // Tham số để xác định chế độ bắt đầu (đăng nhập hay đăng ký)

  const AuthPage({super.key, this.initialMode = true}); // Mặc định là đăng nhập

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _isLoginMode;

  @override
  void initState() {
    super.initState();
    _isLoginMode = widget.initialMode;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy tham số từ route arguments
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      setState(() {
        _isLoginMode = arguments['isLoginMode'] ?? widget.initialMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            color: Colors.white, // Đặt màu nền cố định
          ),
        ),
        backgroundColor: Colors.white, // Màu nền của AppBar
        elevation: 0, // Loại bỏ bóng của AppBar
        automaticallyImplyLeading: false, // Ẩn nút quay lại
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black), // Biểu tượng dấu "x"
            onPressed: () {
              Navigator.of(context).pop(); // Quay lại màn hình trước đó khi nhấn vào biểu tượng
            },
          ),
          const SizedBox(width: 16), // Khoảng cách giữa dấu "x" và cạnh phải màn hình
        ],
      ),
      resizeToAvoidBottomInset: true, // Đảm bảo nội dung không bị tràn khi bàn phím xuất hiện
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Ẩn bàn phím khi nhấn ra ngoài các trường nhập liệu
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: SingleChildScrollView(
              // Đảm bảo rằng nội dung có thể cuộn khi cần
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      height: 130,
                      width: 130,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo.png'), // Đường dẫn tới logo
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5), // Khoảng cách giữa logo và tiêu đề
                    const Text(
                      'HanziiStory',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.green
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Tùy chọn giữa đăng nhập và đăng ký
                    _isLoginMode ? _buildLoginForm() : _buildSignUpForm(),

                    // Chuyển đổi giữa chế độ đăng nhập và đăng ký cùng với quên mật khẩu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLoginMode = !_isLoginMode;
                            });
                          },
                          child: Text(
                            _isLoginMode
                                ? 'Chưa có tài khoản? Đăng ký'
                                : 'Đã có tài khoản? Đăng nhập',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                        if (_isLoginMode) // Chỉ hiển thị nút quên mật khẩu khi ở chế độ đăng nhập
                          TextButton(
                            onPressed: () {
                              // Xử lý quên mật khẩu ở đây
                            },
                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Form đăng nhập
  Widget _buildLoginForm() {
    return Column(
      children: [
        // Email Input
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Password Input
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Login Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Xử lý đăng nhập ở đây
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Màu nền của nút
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Đăng nhập',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Form đăng ký
  Widget _buildSignUpForm() {
    return Column(
      children: [
        // Email Input
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Password Input
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Confirm Password Input
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Xác nhận mật khẩu',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Sign Up Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Xử lý đăng ký ở đây
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Màu nền của nút
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Đăng ký',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
