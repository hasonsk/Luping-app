class Sentence {
  final int id;
  final String sentences;
  final String pinyin;
  final String meaning;
  final String searchquery;

  Sentence({
    required this.id,
    required this.sentences,
    required this.pinyin,
    required this.meaning,
    required this.searchquery,
  });

  // Chuyển đối tượng Sentence thành Map để lưu trữ trong SQLite
  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Sentences': sentences,
      'Pinyin': pinyin,
      'Meaning': meaning,
      'Searchquery': searchquery,
    };
  }

  // Chuyển Map từ SQLite thành đối tượng Sentence
  factory Sentence.fromMap(Map<String, dynamic> map) {
    return Sentence(
      id: map['Id'],
      sentences: map['Sentences'],
      pinyin: map['Pinyin'],
      meaning: map['Meaning'],
      searchquery: map['Searchquery'],
    );
  }
}
