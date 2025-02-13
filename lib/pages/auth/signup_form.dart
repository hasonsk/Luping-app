import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  void _handleSignUp() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorMessage = "Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _errorMessage = "Email không hợp lệ.");
      return;
    }

    if (AuthService.emailExists(email)) {
      setState(() => _errorMessage = "Email này đã được đăng ký.");
      return;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = "Mật khẩu phải có ít nhất 6 ký tự.");
      return;
    }

    if (password != confirmPassword) {
      setState(() => _errorMessage = "Mật khẩu xác nhận không khớp.");
      return;
    }

    // Thành công
    AuthService.registerUser(email, password);
    setState(() => _errorMessage = null);
        Navigator.of(context).pushReplacementNamed('/main');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng ký thành công!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          decoration: const InputDecoration(
            labelText: 'Mật khẩu',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Xác nhận mật khẩu',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        if (_errorMessage != null)
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 10),
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
}
