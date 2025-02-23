import 'package:flutter/material.dart';
import 'package:luping/models/word.dart';
import 'flashcard_item.dart';

class Flashcard {
  final String id;
  final DateTime createdAt;
  final String ownerId;
  final List<Word> items;
  final bool isPublic;
  String title;

  Flashcard({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.ownerId,
    required this.items,
    this.isPublic = false, // Mặc định là riêng tư
  });
}
