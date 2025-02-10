
import 'package:hanjii/models/lesson.dart';

class Book {
  final int id;
  final String title;
  final String author;
  final String imageUrl;
  final List<Lesson> lessons;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.lessons,
  });
}
