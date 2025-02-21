class Word {
  final int id;
  final String word;
  final String? pinyin;
  final List<String>? meaning;
  final String? hanviet;
  final List<String>? cannghia;
  final List<String>? trainghia;
  final String? image;
  final String? shortMeaning; // Đổi tên tham số thành shortMeaning
  final String? hskLevel;

  Word({
    required this.id,
    required this.word,
    required this.pinyin,
    required this.meaning,
    required this.hanviet,
    required this.cannghia,
    required this.trainghia,
    required this.image,
    required this.shortMeaning, // Đổi tên tham số thành shortMeaning
    required this.hskLevel,
  });

  factory Word.fromMap(Map<String, dynamic> map) {
    // Hàm helper để chuyển đổi String thành List<String>
    List<String> convertToList(dynamic value) {
      if (value == null) return [];
      if (value is List) return List<String>.from(value);
      if (value is String) {
        return value.split(',').map((e) => e.trim()).toList();
      }
      return [];
    }

    return Word(
      id: map['id'] ?? 0,
      word: map['word'],
      pinyin: map['pinyin'],
      meaning: convertToList(map['meaning']),
      hanviet: map['hanviet'],
      cannghia: convertToList(map['cannghia']),
      trainghia: convertToList(map['trainghia']),
      image: map['image'],
      shortMeaning: map['shortMeaning'],
      hskLevel: map['hskLevel'],
    );
  }
}
