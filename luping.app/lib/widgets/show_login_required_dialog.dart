import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:luping/pages/auth/auth_page.dart';

void showLoginRequiredDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Yêu cầu đăng nhập"),
        content:
            const Text("Bạn cần đăng nhập để tiếp tục sử dụng tính năng này."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ở lại", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AuthPage()));
            },
            child: const Text("Đăng nhập"),
          ),
        ],
      );
    },
  );
}
