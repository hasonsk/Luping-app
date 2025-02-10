// word.dart
class Word {
  final int id;
  final String? word;
  final String? pinyin;
  final List<String>? meaning;
  final String? hanviet;
  final List<String>? cannghia;
  final List<String>? trainghia;
  final String? image;
  final String? shortMeaning;  // Đổi tên tham số thành shortMeaning
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
    required this.shortMeaning,  // Đổi tên tham số thành shortMeaning
    required this.hskLevel,
  });
}
