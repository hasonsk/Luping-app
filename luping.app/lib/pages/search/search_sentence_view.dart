import 'package:flutter/material.dart';
import 'package:hanjii/models/sentence.dart';

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
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Câu tiếng Trung + Icon âm thanh (trên cùng một hàng)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              item.sentences,
                              style: const TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.volume_up_outlined, size: 20, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 4), // Khoảng cách giữa sentence và pinyin
                      Text(
                        item.pinyin,
                        style: const TextStyle(fontSize: 14, color: Colors.orange),
                      ),
                      const SizedBox(height: 8), // Khoảng cách giữa Pinyin và Meaning

                      /// Nghĩa tiếng Việt
                      Text(
                        item.meaning,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
