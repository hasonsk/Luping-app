import 'package:flutter/material.dart';
import 'package:hanjii/pages/lessons/kanji/kanji_screen.dart';
import 'package:hanjii/pages/lessons/vocabulary/vocabulary_screen.dart';
import 'package:hanjii/pages/lessons/listening/listening_screen.dart';
import 'package:hanjii/pages/lessons/conversation/conversation_screen.dart';
import '../../domain/models/lesson.dart';
import '../../domain/usecases/play_audio_usecase.dart';
import '../../domain/usecases/start_recording_usecase.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

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

  void _navigateToKaiwaScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          playAudioUseCase: context.read<PlayAudioUseCase>(),
          startRecordingUseCase: context.read<StartRecordingUseCase>(),
          conversation: lesson.lessonConversation,
        ),
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
            Container(
              color: Colors.grey[100],
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Row(
                children: [
                  Text(
                    'Bài ${lesson.lessonId} :',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lesson.lessonName,
                      style: const TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(width: 1, height: 50, color: Colors.green[100]),
                const SizedBox(width: 10),
                _buildButton(context, 'Chuẩn bị', () => _navigateToKanjiScreen(context), width: 70),
                const SizedBox(width: 20),
                _buildButton(context, 'Từ mới', () => _navigateToVocabularyScreen(context), width: 70),
                const SizedBox(width: 20),
                _buildButton(context, 'File nghe', () => _navigateToAudioScreen(context), width: 70),
                const SizedBox(width: 20),
                _buildButton(context, 'Hội thoại', () => _navigateToKaiwaScreen(context), width: 70),
              ],
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

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed, {double? width}) {
    return Container(
      width: width, // Thêm tham số width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          textStyle: const TextStyle(fontSize: 12), // Giảm font size
          side: const BorderSide(color: Colors.grey, width: 0.5),
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text),
      ),
    );
  }
}
