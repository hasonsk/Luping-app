import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Thêm GetX
import 'package:hanjii/pages/mainscreen.dart'; // Nhập trang MainScreen

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    // Giả sử có dữ liệu cần tải trước khi điều hướng đến MainScreen
    _loadData();
  }

  Future<void> _loadData() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 20));
      setState(() {
        _progress = i / 100; // Cập nhật tiến độ
      });
    }

    // Điều hướng đến MainScreen sau khi dữ liệu đã sẵn sàng
    Get.off(() => const MainScreen()); // Sử dụng hàm để trả về widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('assets/logo.png'), width: 150),
              const SizedBox(height: 20),
              const Text(
                'HanziiStory',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 3.0,
                ),
              ),
              const SizedBox(height: 20),
              // Bo góc và thêm shadow cho progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Bo góc
                child: Container(
                  width: 200, // Chiều rộng của progress bar
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Màu nền của progress bar
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Đổ bóng xuống dưới
                      ),
                    ],
                  ),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 10, // Chiều cao của progress bar
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green), // Màu cho phần tiến độ
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Hiển thị phần trăm tiến độ
              Text(
                '${(_progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
