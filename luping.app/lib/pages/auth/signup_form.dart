import 'dart:developer';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final AuthService _auth = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Họ và tên',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          onChanged: (value) {
            setState(() => _showConfirmPassword = value.isNotEmpty);
          },
          decoration: const InputDecoration(
            labelText: 'Mật khẩu',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        if (_showConfirmPassword)
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Xác nhận mật khẩu',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
          ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 10),
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleSignUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Đăng ký', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _handleSignUp() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (!_validateInputs(name, email, password, confirmPassword)) return;

    bool isSuccess = await AuthService.signUp(email, password, name);

    if (isSuccess) {
      final user = await _auth.createUser(email, password);
      if (user != null) {
        log("User created successfully with Firebase");
        setState(() => _errorMessage = null);
        Navigator.of(context).pushReplacementNamed('/main');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký thành công!")),
        );
      } else {
        log("Failed to create user with Firebase");
        setState(() => _errorMessage = "Đăng ký thất bại. Vui lòng thử lại.");
      }
    } else {
      setState(() => _errorMessage = "Đăng ký thất bại. Vui lòng thử lại.");
    }
  }

  bool _validateInputs(String name, String email, String password, String confirmPassword) {
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorMessage = "Vui lòng nhập đầy đủ thông tin.");
      return false;
    }

    if (name.length < 3) {
      setState(() => _errorMessage = "Họ và tên phải có ít nhất 3 ký tự.");
      return false;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      setState(() => _errorMessage = "Họ và tên không được chứa số hoặc ký tự đặc biệt.");
      return false;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _errorMessage = "Email không hợp lệ.");
      return false;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = "Mật khẩu phải có ít nhất 6 ký tự.");
      return false;
    }

    if (password != confirmPassword) {
      setState(() => _errorMessage = "Mật khẩu xác nhận không khớp.");
      return false;
    }

    return true;
  }
}
