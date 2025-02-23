import 'package:flutter/material.dart';
import 'package:luping/models/sentence.dart';

class SearchSentencesView extends StatelessWidget {
  final List<Sentence> list;

  const SearchSentencesView({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return _buildSentenceCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSentenceCard(Sentence item) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSentenceRow(item.sentences),
            const SizedBox(height: 4),
            _buildPinyinText(item.pinyin),
            const SizedBox(height: 8),
            _buildMeaningText(item.meaning),
          ],
        ),
      ),
    );
  }

  Widget _buildSentenceRow(String sentence) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            sentence,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.volume_up_outlined, size: 20, color: Colors.grey),
      ],
    );
  }

  Widget _buildPinyinText(String pinyin) {
    return Text(
      pinyin,
      style: const TextStyle(fontSize: 14, color: Colors.orange),
    );
  }

  Widget _buildMeaningText(String meaning) {
    return Text(
      meaning,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}
