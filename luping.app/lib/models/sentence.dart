class Sentence {
  final int id;
  final String sentence;
  final String pinyin;
  final String meaning;
  final String searchquery;

  Sentence({
    required this.id,
    required this.sentence,
    required this.pinyin,
    required this.meaning,
    required this.searchquery,
  });

  // Chuyển đối tượng Sentence thành Map để lưu trữ trong SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sentence': sentence,
      'pinyin': pinyin,
      'meaning': meaning,
      'searchquery': searchquery,
    };
  }

  // Chuyển Map từ SQLite thành đối tượng Sentence
  factory Sentence.fromMap(Map<String, dynamic> map) {

    return Sentence(
      id: map['id'] ?? 0, // Nếu null, đặt giá trị mặc định để tránh lỗi
      sentence: map['sentence'] ?? '',
      pinyin: map['pinyin'] ?? '',
      meaning: map['meaning'] ?? '',
      searchquery: map['searchquery'] ?? '',
    );
  }

}
