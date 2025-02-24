import 'dart:developer';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          labelText: 'Email',
          prefixIcon: Icons.email,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _passwordController,
          labelText: 'Mật khẩu',
          prefixIcon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        if (_errorMessage != null)
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 10),
        _buildLoginButton(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Đăng nhập', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  void _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    try {
      bool isSuccess = await AuthService.login(email, password);
      if (isSuccess) {
        final user = await _auth.loginUser(email, password);
        if (user != null) {
          log("User login successfully with Firebase");
          setState(() => _errorMessage = null);
          Navigator.of(context).pushReplacementNamed('/main');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đăng nhập thành công!")),
          );
        } else {
          _setErrorMessage("Đăng nhập thất bại. Vui lòng thử lại.");
        }
      } else {
        _setErrorMessage("Đăng nhập thất bại. Vui lòng thử lại.");
      }
    } catch (e) {
      _setErrorMessage("Lỗi: ${e.toString()}");
    }
  }

  void _setErrorMessage(String message) {
    log(message);
    setState(() => _errorMessage = message);
  }
}
