import 'package:flutter/material.dart';
import 'package:hanjii/pages/lessons/conversation_screen.dart';
import 'package:hanjii/pages/lessons/kanji_screen.dart';
import 'package:hanjii/pages/lessons/reference_screen.dart';
import 'package:hanjii/pages/lessons/vocabulary_screen.dart';
import 'package:hanjii/pages/lessons/audio_screen.dart';
import '../../models/lesson.dart';

class LessonItem extends StatelessWidget {
  final Lesson lesson;

  const LessonItem({Key? key, required this.lesson}) : super(key: key);

  void _navigateToKanjiScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KanjiScreen(lesson: lesson)),
    );
  }

  void _navigateToVocabularyScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VocabularyScreen(lesson: lesson)),
    );
  }

  void _navigateToAudioScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AudioScreen(lesson: lesson)),
    );
  }

  void _navigateToConverScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConversationScreen(lesson: lesson)),
    );
  }

  void _navigateToReferScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReferenceScreen(lesson: lesson)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[100],
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Row(
                children: [
                  Text(
                    'Bài ${lesson.index} :',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lesson.title,
                      style: const TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
                child: Row(
                  children: [
                    _buildSection(
                      title: '1.1 Chuẩn bị bài',
                      buttons: [
                        _buildButton(context, 'Chuẩn bị', () => _navigateToKanjiScreen(context)),
                        _buildButton(context, 'Từ mới', () => _navigateToVocabularyScreen(context)),
                      ],
                    ),
                    SizedBox(width: 20), // Khoảng cách giữa các nhóm cột
                    _buildSection(
                      title: '1.2 Học tại lớp',
                      buttons: [
                        _buildButton(context, 'Hội thoại', () => _navigateToConverScreen(context)),
                      ],
                    ),
                    SizedBox(width: 20),
                    _buildSection(
                      title: '1.3 Ôn tại nhà',
                      buttons: [
                        _buildButton(context, 'File nghe', () => _navigateToAudioScreen(context)),
                        _buildButton(context, 'Tham khảo', () => _navigateToReferScreen(context)),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        Positioned(
          top: 3,
          right: 0,
          child: Checkbox(
            value: false,
            onChanged: (bool? value) {},
            activeColor: Colors.green,
          ),
        )
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        textStyle: const TextStyle(fontSize: 13),
        side: const BorderSide(color: Colors.grey, width: 0.5),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text),
    );
  }

  Widget _buildTitle(String title) {
    return Row(
      children: [
        Icon(Icons.add, color: Colors.green,size: 16),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // Hàm tạo khối có viền và hiệu ứng nổi
  Widget _buildSection({required String title, required List<Widget> buttons}) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền
        borderRadius: BorderRadius.circular(12), // Bo góc
        border: Border.all(color: Colors.grey.shade300, width: 1), // Viền
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Màu đổ bóng
            blurRadius: 8, // Độ mờ của bóng
            spreadRadius: 2, // Độ lan rộng của bóng
            offset: Offset(2, 4), // Vị trí bóng đổ
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTitle(title),
          Row(
            children: [
              SizedBox(width: 10),
              ...buttons.expand((button) => [button, SizedBox(width: 15)]).toList(), // Thêm khoảng cách giữa các button
            ],
          ),
        ],
      ),
    );
  }

}
