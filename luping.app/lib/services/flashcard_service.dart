import 'package:flutter/material.dart';
import '../domain/models/flashcard.dart';

const String userId = "user_123";

final List<Flashcard> flashcards = [
  Flashcard(
    id: "flashcard_001",
    title: "HSK 1 Vocabulary",
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ownerId: userId,
    isPublic: true,
    items: [
      FlashcardItem(
        question: "谢谢 (xièxiè)",
        answer: "Cảm ơn",
      ),
      FlashcardItem(
        question: "不客气 (bú kèqì)",
        answer: "Không có gì",
      ),
      FlashcardItem(
        question: "你好 (nǐ hǎo)",
        answer: "Xin chào",
      ),
    ],
  ),
  Flashcard(
    id: "flashcard_002",
    title: "HSK 2 Vocabulary",
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ownerId: userId,
    isPublic: false,
    items: [
      FlashcardItem(
        question: "今天 (jīntiān)",
        answer: "Hôm nay",
      ),
      FlashcardItem(
        question: "明天 (míngtiān)",
        answer: "Ngày mai",
      ),
      FlashcardItem(
        question: "昨天 (zuótiān)",
        answer: "Hôm qua",
      ),
    ],
  ),
  Flashcard(
    id: "flashcard_003",
    title: "Basic Chinese Phrases",
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ownerId: "user_456", // Một user khác
    isPublic: true,
    items: [
      FlashcardItem(
        question: "请问 (qǐngwèn)",
        answer: "Xin hỏi",
      ),
      FlashcardItem(
        question: "对不起 (duìbuqǐ)",
        answer: "Xin lỗi",
      ),
      FlashcardItem(
        question: "没关系 (méi guānxi)",
        answer: "Không sao",
      ),
    ],
  ),
];
