import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/lesson.dart';

class ReferenceScreen extends StatelessWidget {
  final Lesson lesson;

  const ReferenceScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Bài ${lesson.lessonPosition} / Tham khảo',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.white, // Màu nền của AppBar
        foregroundColor: Colors.black,
        elevation: 4,
        centerTitle: true,
        shadowColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white, // Đặt màu nền Status Bar trùng với AppBar
          statusBarIconBrightness: Brightness.dark, // Giữ icon status bar màu tối
        ),
      ),
      body: Center(
        child: Text(
          'Nội dung tài liệu tham khảo:',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
