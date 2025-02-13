import '../models/book.dart';
import '../models/lesson.dart';

final List<Book> books = [
  Book(
    id: 1,
    title: 'Giáo trình Hán ngữ chuẩn HSK 1',
    author: 'Liu Xun',
    imageUrl: 'assets/chuanhanngu_1.png',
    lessons: [
      Lesson(
        index: 1,
        title: '你好 - Xin chào',
        vocabulary: ['你好 (nǐ hǎo) - Xin chào', '我 (wǒ) - Tôi', '你 (nǐ) - Bạn'],
        kanji: ['你好 - Xin chào', '我 - Tôi', '你 - Bạn'],
        audioFiles: [
          AudioFile(title: 'Hội thoại', filePath: 'audio/hsk1_lesson2_1.mp3'),
          AudioFile(title: 'Từ vựng 1', filePath: 'audio/hsk1_lesson2_2.mp3'),
          AudioFile(title: 'Bài tập 1', filePath: 'audio/hsk1_lesson2_3.mp3'),
        ],
      ),
      Lesson(
        index: 2,
        title: '谢谢你 - Cảm ơn bạn',
        vocabulary: ['谢谢 (xièxiè) - Cảm ơn', '不客气 (bú kèqì) - Không có gì'],
        kanji: ['谢谢 - Cảm ơn', '不客气 - Không có gì'],
        audioFiles: [
          AudioFile(title: 'Hội thoại', filePath: 'audio/hsk1_lesson2_1.mp3'),
          AudioFile(title: 'Từ vựng 1', filePath: 'audio/hsk1_lesson2_2.mp3'),
          AudioFile(title: 'Bài tập 1', filePath: 'audio/hsk1_lesson2_3.mp3'),
        ],
      ),
    ],
  ),
  Book(
    id: 2,
    title: 'Giáo trình Hán ngữ chuẩn HSK 2',
    author: 'Liu Xun',
    imageUrl: 'assets/chuanhanngu_2.png',
    lessons: [
      Lesson(
        index: 1,
        title: '今天几号 - Hôm nay ngày mấy?',
        vocabulary: ['今天 (jīntiān) - Hôm nay', '几号 (jǐ hào) - Ngày mấy'],
        kanji: ['今天 - Hôm nay', '几号 - Ngày mấy'],
        audioFiles: [
          AudioFile(title: 'Hội thoại', filePath: 'audio/hsk1_lesson2_1.mp3'),
          AudioFile(title: 'Từ vựng 1', filePath: 'audio/hsk1_lesson2_2.mp3'),
          AudioFile(title: 'Bài tập 1', filePath: 'audio/hsk1_lesson2_3.mp3'),
        ],
      ),
    ],
  ),
];
