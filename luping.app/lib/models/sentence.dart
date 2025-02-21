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

    final sentence = Sentence(
      id: map['id'] as int? ?? 0, // Đổi 'Id' thành 'id'
      sentences: map['sentence'] as String? ?? '', // Đổi 'Sentences' thành 'sentence'
      pinyin: map['pinyin'] as String? ?? '', // Đổi 'Pinyin' thành 'pinyin'
      meaning: map['meaning'] as String? ?? '', // Đổi 'Meaning' thành 'meaning'
      searchquery: map['searchquery'] as String? ?? '', // Đổi 'Searchquery' thành 'searchquery'
    );

    return sentence;
  }



}
