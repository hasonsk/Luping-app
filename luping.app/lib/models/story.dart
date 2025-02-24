import 'dart:convert';
class Story {
  final int id;
  final String character;
  final String pinyin;
  final String hanviet;
  final String bothu;
  final String lucthu;
  final String sonet;
  final List<String>? bothanhphan;
  final List<String> meaning;
  final String image;
  final List<String> mnemonic_v_seperate;
  final String mnemonic_v_content;
  final List<String>? mnemonic_v_media;
  final String? mnemonic_c_content;
  final String? mnemonic_c_media;
  final String? mnemonic_k_content;
  final String? mnemonic_k_media;
  final String mp3;

  Story({
    required this.id,
    required this.character,
    required this.pinyin,
    required this.hanviet,
    required this.bothu,
    required this.lucthu,
    required this.sonet,
    required this.bothanhphan,
    required this.meaning,
    required this.image,
    required this.mnemonic_v_seperate,
    required this.mnemonic_v_content,
    required this.mnemonic_v_media,
    required this.mnemonic_c_content,
    required this.mnemonic_c_media,
    required this.mnemonic_k_content,
    required this.mnemonic_k_media,
    required this.mp3,
  });

  factory Story.fromMap(Map<String, dynamic> map) {
    // Hàm helper để chuyển đổi String thành List<String>
    List<String> convertToList(dynamic value) {
      if (value == null) return [];
      if (value is List) return List<String>.from(value);
      if (value is String) {
        try {
          // Kiểm tra xem có phải chuỗi JSON không
          final decoded = jsonDecode(value);
          if (decoded is List) {
            return List<String>.from(decoded.map((e) => e.toString().trim()));
          }
        } catch (_) {
          // Nếu không phải JSON, thì tách bằng dấu phẩy như cũ
          return value.split(',').map((e) => e.trim()).toList();
        }
      }
      return [];
    }

    return Story(
      id: map['id'] ?? 0,
      character: map['character'],
      pinyin: map['pinyin'],
      hanviet: map['hanviet'],
      bothu: map['bothu'],
      lucthu: map['lucthu'],
      sonet: map['sonet'],
      bothanhphan: convertToList(map['bothanhphan']),
      meaning: convertToList(map['meaning']),
      image: map['image'],
      mnemonic_v_seperate: convertToList(map['mnemonic_v_seperate']),
      mnemonic_v_content: map['mnemonic_v_content'],
      mnemonic_v_media: convertToList(map['mnemonic_v_media']),
      mnemonic_c_content: map['mnemonic_c_content'],
      mnemonic_c_media: map['mnemonic_c_media'],
      mnemonic_k_content: map['mnemonic_k_content'],
      mnemonic_k_media: map['mnemonic_k_media'],
      mp3: map['mp3'],
    );
  }
}
