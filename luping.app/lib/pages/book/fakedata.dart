import '../../models/audio_file.dart';
import '../../models/book.dart';
import '../../models/lesson.dart';
import '../../models/word.dart';

final Book selectedBook = Book(
  bookId: 1,
  bookName: 'Giáo trình Hán ngữ chuẩn HSK 1',
  bookAuthor: 'Liu Xun',
  bookImageUrl: 'assets/chuanhanngu_1.png',
  bookDifficult: 1,
  vocabCount: 3,
  lessons: [
    Lesson(
      lessonId: 1,
      lessonPosition: 1,
      lessonName: '你好 - Xin chào',
      vocabulary: [
        Word(id: 1, word: '你好', pinyin: 'nǐ hǎo', meaning: ['Xin chào'], hanviet: 'Chào bạn', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
        Word(id: 2, word: '我', pinyin: 'wǒ', meaning: ['Tôi'], hanviet: 'Tôi', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
        Word(id: 3, word: '你', pinyin: 'nǐ', meaning: ['Bạn'], hanviet: 'Bạn', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
      ],
      kanji: [
        Word(id: 1, word: '你', pinyin: 'nǐ', meaning: ['Bạn'], hanviet: 'Bạn', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
        Word(id: 2, word: '好', pinyin: 'hǎo', meaning: ['Tốt'], hanviet: 'Tốt', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
      ],
      lessonConversation: ["你好", "我叫", "我来自", "我今年"],
      lessonListening: [
        AudioFile(title: 'Hội thoại', filePath: 'audio/hsk1_lesson2_1.mp3'),
        AudioFile(title: 'Từ vựng 1', filePath: 'audio/hsk1_lesson2_2.mp3'),
        AudioFile(title: 'Bài tập 1', filePath: 'audio/hsk1_lesson2_3.mp3'),
      ],
      lessonReference: [],
    ),
    Lesson(
      lessonId: 2,
      lessonPosition: 2,
      lessonName: '谢谢你 - Cảm ơn bạn',
      vocabulary: [
        Word(id: 4, word: '谢谢', pinyin: 'xièxiè', meaning: ['Cảm ơn'], hanviet: 'Cảm ơn', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
        Word(id: 5, word: '不客气', pinyin: 'bú kèqì', meaning: ['Không có gì'], hanviet: 'Không có gì', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '1'),
      ],
      kanji: [],
      lessonConversation: ["你好吗？", "最近怎么样？", "祝你身体健康！"],
      lessonListening: [
        AudioFile(title: 'Hội thoại', filePath: 'audio/hsk1_lesson2_1.mp3'),
        AudioFile(title: 'Từ vựng 1', filePath: 'audio/hsk1_lesson2_2.mp3'),
        AudioFile(title: 'Bài tập 1', filePath: 'audio/hsk1_lesson2_3.mp3'),
      ],
      lessonReference: [],
    ),
  ],
);