import 'package:flutter/material.dart';
import '../models/flashcard.dart';

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
        frontText: "谢谢 (xièxiè)",
        backText: "Cảm ơn",
      ),
      FlashcardItem(
        frontText: "不客气 (bú kèqì)",
        backText: "Không có gì",
      ),
      FlashcardItem(
        frontText: "你好 (nǐ hǎo)",
        backText: "Xin chào",
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
        frontText: "今天 (jīntiān)",
        backText: "Hôm nay",
      ),
      FlashcardItem(
        frontText: "明天 (míngtiān)",
        backText: "Ngày mai",
      ),
      FlashcardItem(
        frontText: "昨天 (zuótiān)",
        backText: "Hôm qua",
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
        frontText: "请问 (qǐngwèn)",
        backText: "Xin hỏi",
      ),
      FlashcardItem(
        frontText: "对不起 (duìbuqǐ)",
        backText: "Xin lỗi",
      ),
      FlashcardItem(
        frontText: "没关系 (méi guānxi)",
        backText: "Không sao",
      ),
    ],
  ),
];
