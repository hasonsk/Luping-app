import 'package:flutter/material.dart';
import 'package:luping/pages/lessons/conversation/conversation_screen.dart';
import 'package:luping/pages/lessons/reference/reference_screen.dart';
import 'package:luping/pages/lessons/vocabulary/vocabulary_screen.dart';
import 'package:luping/pages/lessons/audio/audio_screen.dart';
import '../../models/lesson.dart';

class LessonItem extends StatefulWidget {
  final Lesson lesson;

  const LessonItem({super.key, required this.lesson});

  @override
  _LessonItemState createState() => _LessonItemState();
}

class _LessonItemState extends State<LessonItem> {
  bool _isExpanded = false;
  // bool _isChecked = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _navigateToKanjiScreen(BuildContext context) {
    _navigateWithFadeTransition(
      context,
      VocabularyScreen(
        lessonPosition: widget.lesson.lessonPosition,
        vocabularies: widget.lesson.kanji,
        title: "Hán tự",
      ),
    );
  }

  void _navigateToVocabularyScreen(BuildContext context) {
    _navigateWithFadeTransition(
      context,
      VocabularyScreen(
        lessonPosition: widget.lesson.lessonPosition,
        vocabularies: widget.lesson.vocabulary,
        title: "Từ vựng",
      ),
    );
  }

  void _navigateToAudioScreen(BuildContext context) {
    _navigateWithFadeTransition(context, AudioScreen(lesson: widget.lesson));
  }

  void _navigateToConverScreen(BuildContext context) {
    _navigateWithFadeTransition(
        context, ConversationScreen(lesson: widget.lesson));
  }

  void _navigateToReferScreen(BuildContext context) {
    _navigateWithFadeTransition(
        context, ReferenceScreen(lesson: widget.lesson));
  }

// Hàm chung để thêm hiệu ứng fade-in khi chuyển màn hình
  void _navigateWithFadeTransition(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề bài học - Nhấn vào sẽ mở hoặc đóng danh sách
            GestureDetector(
              onTap: _toggleExpand,
              child: Container(
                color: Colors.grey[100],
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Bài ${widget.lesson.lessonPosition} :',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.lesson.lessonName,
                        style: const TextStyle(fontSize: 16),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(
                      width: 35,
                    )
                  ],
                ),
              ),
            ),
            // Chỉ hiển thị nếu _isExpanded == true
            if (_isExpanded)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSection(
                        title: '1.1 Chuẩn bị bài',
                        buttons: [
                          _buildButton(context, 'Hán tự',
                              () => _navigateToKanjiScreen(context)),
                          _buildButton(context, 'Từ vựng',
                              () => _navigateToVocabularyScreen(context)),
                        ],
                      ),
                      SizedBox(width: 20),
                      _buildSection(
                        title: '1.2 Học tại lớp',
                        buttons: [
                          _buildButton(context, 'Hội thoại',
                              () => _navigateToConverScreen(context)),
                          _buildButton(context, 'File nghe',
                              () => _navigateToAudioScreen(context)),
                        ],
                      ),
                      SizedBox(width: 20),
                      _buildSection(
                        title: '1.3 Ôn tại nhà',
                        buttons: [
                          _buildButton(context, 'Tham khảo',
                              () => _navigateToReferScreen(context)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
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
        Icon(Icons.star, color: Colors.orange, size: 16),
        SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.grey.shade600),
        ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> buttons}) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTitle(title),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 10),
              ...buttons
                  .expand((button) => [button, SizedBox(width: 15)])
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }
}
