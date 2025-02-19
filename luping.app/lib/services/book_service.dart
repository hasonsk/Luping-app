import '../domain/models/audio_file.dart';
import '../domain/models/book.dart';
import '../domain/models/conversation_file.dart';
import '../domain/models/lesson.dart';
import '../domain/models/word.dart';

final List<Book> books = [
  Book(
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
        lessonConversation: ConversationFile(filePath: 'audio/conversation_1_1.mp3', conversationText: '你好你好你好你好你好你好你好你好你好你好'),
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
        lessonConversation: ConversationFile(filePath: 'audio/conversation_2_1.mp3', conversationText: '谢谢'),
        lessonListening: [
          AudioFile(title: 'Hội thoại', filePath: 'audio/hsk1_lesson2_1.mp3'),
          AudioFile(title: 'Từ vựng 1', filePath: 'audio/hsk1_lesson2_2.mp3'),
          AudioFile(title: 'Bài tập 1', filePath: 'audio/hsk1_lesson2_3.mp3'),
        ],
        lessonReference: [],
      ),
    ],
  ),
  Book(
    bookId: 2,
    bookName: 'Giáo trình Hán ngữ chuẩn HSK 2',
    bookAuthor: 'Liu Xun',
    bookImageUrl: 'assets/chuanhanngu_2.png',
    bookDifficult: 2,
    vocabCount: 2,
    lessons: [
      Lesson(
        lessonId: 1,
        lessonPosition: 1,
        lessonName: '今天几号 - Hôm nay ngày mấy?',
        vocabulary: [
          Word(id: 6, word: '今天', pinyin: 'jīntiān', meaning: ['Hôm nay'], hanviet: 'Hôm nay', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '2'),
          Word(id: 7, word: '几号', pinyin: 'jǐ hào', meaning: ['Ngày mấy'], hanviet: 'Ngày mấy', cannghia: [], trainghia: [], image: null, shortMeaning: null, hskLevel: '2'),
        ],
        kanji: [],
        lessonConversation: ConversationFile(filePath: 'audio/conversation_3_1.mp3', conversationText: '今天几号?'),
        lessonListening: [
          AudioFile(title: 'Hội thoại', filePath: 'audio/hsk2_lesson1_1.mp3'),
          AudioFile(title: 'Từ vựng 1', filePath: 'audio/hsk2_lesson1_2.mp3'),
          AudioFile(title: 'Bài tập 1', filePath: 'audio/hsk2_lesson1_3.mp3'),
        ],
        lessonReference: [],
      ),
    ],
  ),
];