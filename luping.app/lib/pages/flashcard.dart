import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Flashcard extends StatefulWidget {
  const Flashcard({super.key});

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0), // Đặt chiều cao của AppBar ở đây
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Màu nền của AppBar
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Giảm độ đậm của bóng đổ
                spreadRadius: 0,
                blurRadius: 5.0, // Tăng độ mờ của bóng đổ
                offset: const Offset(0, 2), // Bóng đổ chỉ xuất hiện ở phần dưới
              ),
            ],
          ),
          child: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.white, // Đặt màu nền AppBar thành trắng
            elevation: 0, // Tắt đổ bóng mặc định
            centerTitle: true,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                  Icon(Icons.stacked_bar_chart, color: Colors.green,),
                  SizedBox(width: 4,),
                  Text('Trình tạo Flashcard',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                        side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: Colors.grey, width: 0.5)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.folder_open, size: 20),
                          SizedBox(width: 4),
                          Text('Mở', style: TextStyle(fontSize: 13),),
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: () {},
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_horiz),
                          SizedBox(width: 8),
                          Text('Tạo'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ví dụ : 跑步, 运动, 游泳  ',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    maxLines: null,
                    expands: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
