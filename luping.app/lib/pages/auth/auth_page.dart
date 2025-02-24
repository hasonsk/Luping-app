import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'auth_header.dart';
import 'login_form.dart';
import 'signup_form.dart';

class AuthPage extends StatefulWidget {

  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _isLoginMode;

  @override
  void initState() {
    super.initState();
    _isLoginMode = Get.arguments['isLoginMode'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthHeader(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: 130, width: 130),
                  const SizedBox(height: 5),
                  const Text(
                    'Luping',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.green),
                  ),
                  const SizedBox(height: 30),

                  _isLoginMode ? const LoginForm() : const SignUpForm(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                        child: Text(
                          _isLoginMode ? 'Chưa có tài khoản? Đăng ký' : 'Đã có tài khoản? Đăng nhập',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      if (_isLoginMode)
                        TextButton(
                          onPressed: () {
                            // Xử lý quên mật khẩu
                          },
                          child: const Text('Quên mật khẩu?', style: TextStyle(color: Colors.blue)),
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
    );
  }
}
