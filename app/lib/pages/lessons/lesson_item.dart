import 'package:flutter/material.dart';
import 'package:hanjii/pages/lessons/kanji_screen.dart';
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
            Row(
              children: [
                Container(width: 1, height: 50, color: Colors.green[100]),
                const SizedBox(width: 10),
                _buildButton(context, 'Hán tự', () => _navigateToKanjiScreen(context)),
                const SizedBox(width: 20),
                _buildButton(context, 'Từ vựng', () => _navigateToVocabularyScreen(context)),
                const SizedBox(width: 20),
                _buildButton(context, 'File nghe', () => _navigateToAudioScreen(context)),
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

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        textStyle: const TextStyle(fontSize: 14),
        side: const BorderSide(color: Colors.grey, width: 0.5),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text),
    );
  }
}
