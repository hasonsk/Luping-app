import 'package:cloud_firestore/cloud_firestore.dart';

class HintCharacter {
  final String hanzi;
  final String pinyin;
  final String hanViet;
  final String shortMeaning;

  HintCharacter({
    required this.hanzi,
    required this.pinyin,
    required this.hanViet,
    required this.shortMeaning,
  });

  // Factory constructor to create a hintCharacter from Firestore document
  factory HintCharacter.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HintCharacter(
      hanzi: data['Hanzi'] ?? '',
      pinyin: data['Pinyin'] ?? '',
      hanViet: data['HanViet'] ?? '',
      shortMeaning: data['ShortMeaning'] ?? '',
    );
  }

  factory HintCharacter.fromMap(Map<String, dynamic> map) {
    return HintCharacter(
      hanzi: map['word'] ?? '',
      pinyin: map['pinyin'] ?? '',
      hanViet: map['hanviet'] ?? '',
      shortMeaning: map['shortmeaning'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HintCharacter && other.hanzi == hanzi;
  }

  @override
  int get hashCode => hanzi.hashCode;
}
