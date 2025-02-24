import 'package:luping/models/lesson.dart';

class Book {
  final int bookId;
  final String bookName;
  final String bookAuthor;
  final String bookImageUrl;
  final int bookDifficult;
  final int vocabCount;
  final List<Lesson> lessons;

  Book({
    required this.bookId,
    required this.bookName,
    required this.bookAuthor,
    required this.bookImageUrl,
    required this.bookDifficult,
    required this.vocabCount,
    required this.lessons,
  });
}
