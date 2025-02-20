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
              // print("Rendering item $index: ${item.sentences}, ${item.pinyin}, ${item.meaning}");
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                            ),
                            child: Text(
                              item.sentences,
                              style: const TextStyle(fontSize: 18, color: Colors.red),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.pinyin,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 14, color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Icon(Icons.volume_up_outlined, size: 20, color: Colors.grey),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
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
