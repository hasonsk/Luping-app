import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:luping/models/sentence.dart';
import 'package:flutter_html/flutter_html.dart';

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
              return _buildSentenceCard(index, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSentenceCard(int index, Sentence item) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSentenceRow(index, item.sentence),
            _buildPinyinText(item.pinyin),
            const SizedBox(height: 4),
            _buildMeaningText(item.meaning),
          ],
        ),
      ),
    );
  }



  Widget _buildSentenceRow(int index, String sentence) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Html(
            data: sentence, // Render HTML thay vì hiển thị thô
            style: {
              "body": Style(fontSize: FontSize(17)), // Điều chỉnh font size
            },
          ),
        ),
        SizedBox(width: 10,),
        const Icon(Icons.volume_up_outlined, size: 20, color: Colors.grey),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildPinyinText(String pinyin) {
    return Text(
      '| ${pinyin} |',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
        fontStyle: FontStyle.italic, // Chuyển sang chữ nghiêng
      ),
    );
  }


  Widget _buildMeaningText(String meaning) {
    return Text(
      meaning,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
    );
  }
}
