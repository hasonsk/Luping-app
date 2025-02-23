import 'package:flutter/material.dart';

class SearchLoadingWidget extends StatelessWidget {
  const SearchLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/loading_green.gif', // Đường dẫn đến ảnh GIF
        width: 60, // Điều chỉnh kích thước nếu cần
        height: 60,
      ),
    );
  }
}
