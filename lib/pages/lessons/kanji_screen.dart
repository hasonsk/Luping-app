import 'package:flutter/material.dart';
import '../../models/lesson.dart';

class KanjiScreen extends StatelessWidget {
  final Lesson lesson;

  const KanjiScreen({Key? key, required this.lesson}) : super(key: key);

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            width: 5,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        if (title == 'Từ vựng') // Add search icon only for "Từ vựng"
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 20, color: Colors.grey),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài ${lesson.index} / Hán tự'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Container(
        color: const Color(0xFFFFF8F5), // Light pink background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Bắt đầu', Colors.green),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(Icons.school, 'Học'),
                  _buildActionButton(Icons.edit, 'Luyện tập'),
                  _buildActionButton(Icons.check, 'Kiểm tra'),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Gần đây', Colors.purple),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: lesson.kanji.length,
                  itemBuilder: (context, index) {
                    return _buildVocabularyCard(lesson.kanji[index], index + 1);
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Từ vựng', Colors.yellow),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: lesson.vocabulary.length,
                  itemBuilder: (context, index) {
                    return _buildVocabularyCard(lesson.vocabulary[index], index + 1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        textStyle: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildVocabularyCard(String vocab, int index) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Center(
        child: Text(
          vocab,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
