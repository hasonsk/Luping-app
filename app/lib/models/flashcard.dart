import 'package:flutter/material.dart';
import 'flashcard_item.dart';

class Flashcard {
  final String id;
  final String title;
  final DateTime createdAt;
  final String ownerId;
  final List<FlashcardItem> items;
  final bool isPublic;

  Flashcard({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.ownerId,
    required this.items,
    this.isPublic = false, // Mặc định là riêng tư
  });
}

class FlashcardItem {
  final String question;
  final String answer;

  FlashcardItem({
    required this.question,
    required this.answer,
  });
}
