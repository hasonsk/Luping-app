import 'reference.dart';
import 'word.dart';
import 'audio_file.dart';

class Lesson {
  final int lessonId;
  final int lessonPosition;
  final String lessonName;
  final List<Word> vocabulary;
  final List<Word> kanji;
  final List<String> lessonConversation;
  final List<AudioFile> lessonListening;
  final List<Reference> lessonReference;

  Lesson({
    required this.lessonId,
    required this.lessonPosition,
    required this.lessonName,
    required this.vocabulary,
    required this.kanji,
    required this.lessonConversation,
    required this.lessonListening,
    required this.lessonReference,
  });
}
