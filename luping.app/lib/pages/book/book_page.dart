import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/book.dart';
import '../lessons/lesson_item.dart';

class BookPage extends StatelessWidget {
  final Book book;

  const BookPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Text(
              book.title,
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(15, 0, 10, 65),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionTitle(Icons.list, 'Mục lục : (${book.lessons.length} bài học)'),
                  const SizedBox(height: 10),
                  _buildProgressSection(0, book.lessons.length),
                  const SizedBox(height: 5),
                  ...book.lessons.map((lesson) => LessonItem(lesson: lesson)).toList(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProgressSection(int completed, int total) {
    return Row(
      children: [
        const SizedBox(width: 2),
        const Icon(Icons.pie_chart_rounded, color: Colors.green, size: 12),
        const SizedBox(width: 10),
        const Text('Tiến độ :', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Text('$completed/$total', style: const TextStyle(color: Colors.green)),
      ],
    );
  }
}
