import 'dart:convert';
class HintStory {
  final int id;
  final String character;
  final String hanviet;
  final String pinyin;
  final List<String> meaning;
  final String image;

  HintStory({
    required this.id,
    required this.character,
    required this.pinyin,
    required this.hanviet,
    required this.meaning,
    required this.image,
  });

  factory HintStory.fromMap(Map<String, dynamic> map) {
    // Hàm helper để chuyển đổi String thành List<String>
    List<String> convertToList(dynamic value) {
      if (value == null) return [];
      if (value is List) return List<String>.from(value);
      if (value is String) {
        try {
          // Nếu value là một chuỗi JSON dạng danh sách, giải mã nó
          var decoded = jsonDecode(value);
          if (decoded is List) return List<String>.from(decoded);
        } catch (e) {
          // Nếu không phải JSON hợp lệ, fallback về split(',')
          return value.split(',').map((e) => e.trim()).toList();
        }
      }
      return [];
    }

    return HintStory(
      id: map['id'] ?? 0,
      character: map['character'],
      pinyin: map['pinyin'],
      hanviet: map['hanviet'],
      meaning: convertToList(map['meaning']),
      image: map['image'],
    );
  }
}
