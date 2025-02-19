class HintStory {
  final int id;
  final String character;
  final String hanviet;
  final String pinyin;
  final List<String> meaning;

  HintStory({
    required this.id,
    required this.character,
    required this.pinyin,
    required this.hanviet,
    required this.meaning,
  });

  factory HintStory.fromMap(Map<String, dynamic> map) {
    // Hàm helper để chuyển đổi String thành List<String>
    List<String> convertToList(dynamic value) {
      if (value == null) return [];
      if (value is List) return List<String>.from(value);
      if (value is String) {
        return value.split(',').map((e) => e.trim()).toList();
      }
      return [];
    }

    return HintStory(
      id: map['id'] ?? 0,
      character: map['character'],
      pinyin: map['pinyin'],
      hanviet: map['hanviet'],
      meaning: convertToList(map['meaning']),
    );
  }
}
