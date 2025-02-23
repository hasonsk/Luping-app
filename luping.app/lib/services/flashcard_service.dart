import 'package:flutter/material.dart';
import 'package:luping/models/flashcard.dart';
import '../models/word.dart';

const String userId = "user_123";

final List<Flashcard> flashcards = [
  Flashcard(
    id: "flashcard_001",
    title: "HSK 1 Vocabulary",
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ownerId: userId,
    isPublic: true,
    items: [
      Word(
        id: 1,
        word: "谢谢",
        pinyin: "xièxiè",
        meaning: ["Cảm ơn"],
        hanviet: "Tạ tạ",
        cannghia: ["Đa tạ"],
        trainghia: ["Không có gì"],
        image: null,
        shortmeaning: "Cảm ơn",
        hskLevel: "1",
      ),
      Word(
        id: 2,
        word: "不客气",
        pinyin: "bú kèqì",
        meaning: ["Không có gì"],
        hanviet: "Bất khách khí",
        cannghia: ["Đừng khách sáo"],
        trainghia: ["Cảm ơn"],
        image: null,
        shortmeaning: "Không có gì",
        hskLevel: "1",
      ),
      Word(
        id: 3,
        word: "你好",
        pinyin: "nǐ hǎo",
        meaning: ["Xin chào"],
        hanviet: "Nhĩ hảo",
        cannghia: ["Chào"],
        trainghia: [],
        image: null,
        shortmeaning: "Xin chào",
        hskLevel: "1",
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
      Word(
        id: 4,
        word: "今天",
        pinyin: "jīntiān",
        meaning: ["Hôm nay"],
        hanviet: "Kim thiên",
        cannghia: ["Ngày này"],
        trainghia: ["Hôm qua"],
        image: null,
        shortmeaning: "Hôm nay",
        hskLevel: "2",
      ),
      Word(
        id: 5,
        word: "明天",
        pinyin: "míngtiān",
        meaning: ["Ngày mai"],
        hanviet: "Minh thiên",
        cannghia: ["Tương lai"],
        trainghia: ["Hôm qua"],
        image: null,
        shortmeaning: "Ngày mai",
        hskLevel: "2",
      ),
    ],
  ),
];
