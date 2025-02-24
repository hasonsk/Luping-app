import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luping/models/word.dart';
import 'package:luping/pages/flashcard/flashcard_content_page.dart';
import 'package:luping/services/search_service.dart';
import '../../models/flashcard.dart';
import '../../models/flashcard_item.dart';
import '../../widgets/show_login_required_dialog.dart';
import 'flashcard_list_page.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _contentController = TextEditingController();

  final List<Flashcard> flashcards = [
    Flashcard(
      id: "flashcard_001",
      title: "HSK 1 Vocabulary",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ownerId: "user_123",
      isPublic: true,
      items: [],
    ),
    Flashcard(
      id: "flashcard_002",
      title: "HSK 2 Vocabulary",
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ownerId: "user_123",
      isPublic: false,
      items: [],
    ),
    Flashcard(
      id: "flashcard_003",
      title: "Basic Chinese Phrases",
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ownerId: "user_456", // Một user khác
      isPublic: true,
      items: [],
    ),
  ];

  void _createFlashcard() async {
    if (_contentController.text.isNotEmpty) {
      // Hiển thị lớp loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // 1. Tách nội dung thành danh sách từ
      List<String> wordList = _contentController.text
          .split(RegExp(r'[,\uFF0C]')) // Thêm dấu phẩy tiếng Trung (U+FF0C))
          .map((word) => word.trim())
          .where((word) => word.isNotEmpty)
          .toList();

      // 2. Gọi fetchWordList để lấy dữ liệu từ database
      final searchService = SearchService();
      List<Word>? words = await searchService.fetchWordList(wordList);

      // Đóng lớp loading
      Navigator.of(context).pop();

      if (words == null || words.isEmpty) {
        // Hiển thị thông báo nếu không tìm thấy từ nào trong database
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không tìm thấy từ nào trong database")),
        );
        return;
      }

      // 3. Tạo Flashcard mới
      final newFlashcard = Flashcard(
        id: "flashcard_${DateTime.now().millisecondsSinceEpoch}",
        title: "Flashcard mới",
        createdAt: DateTime.now(),
        ownerId: "user_123",
        isPublic: false,
        items: words,
      );

      // 4. Chuyển sang FlashcardContentPage và truyền danh sách từ
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlashcardContentPage(flashcard: newFlashcard),
        ),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Giải phóng FocusNode để tránh rò rỉ bộ nhớ
    super.dispose();
  }

  void _unfocusTextField() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          _unfocusTextField, // Khi nhấn vào bất kỳ đâu, bỏ focus khỏi TextField
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 5.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark,
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.stacked_bar_chart, color: Colors.green),
                  SizedBox(width: 4),
                  Text(
                    'Trình tạo Flashcard',
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
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        _unfocusTextField(); // Hủy focus trước khi điều hướng
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FlashcardListPage(flashcards: flashcards),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                        side: WidgetStateProperty.all<BorderSide>(
                          const BorderSide(color: Colors.grey, width: 0.5),
                        ),
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
                          Text(
                            'Mở',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: () {
                        _createFlashcard();
                        _unfocusTextField();
                      },
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
                      controller: _contentController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Ví dụ : 跑步, 运动, 游泳',
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
      ),
    );
  }
}
