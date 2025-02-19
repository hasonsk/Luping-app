class Lesson {
  final int index;
  final String title;
  final List<String> vocabulary;
  final List<String> kanji;
  final List<AudioFile> audioFiles;

  Lesson({
    required this.index,
    required this.title,
    required this.vocabulary,
    required this.kanji,
    required this.audioFiles,
  });
}

class AudioFile {
  final String title;
  final String filePath;

  AudioFile({required this.title, required this.filePath});
}
