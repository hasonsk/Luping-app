import 'package:flutter/material.dart';
import 'word_lobby.dart';
import 'story_lobby.dart';

class SearchLobbyView extends StatelessWidget {
  final String type;

  const SearchLobbyView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == 'word') {
      return const WordLobby();
    } else if (type == 'story') {
      return const StoryLobby();
    } else {
      return const Center(
        child: Text("Loại không hợp lệ", style: TextStyle(fontSize: 18, color: Colors.red)),
      );
    }
  }
}