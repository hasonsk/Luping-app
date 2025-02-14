import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hanjii/models/hintCharacter.dart';  // Import lớp hintCharacter
import 'package:hanjii/models/word.dart';  // Import lớp word
import 'dart:convert'; // Import for JSON decoding

class DatabaseHelper {
  // Hàm mở cơ sở dữ liệu
  static Future<Database> getDatabase() async {
    try {
      final dbPath = join(await getDatabasesPath(), 'HanziStory.sqlite');
      final db = await openDatabase(
        dbPath,
        version: 1,
      );
      print('Connected to the database successfully.');
      return db;
    } catch (e) {
      print('Failed to connect to the database: $e');
      rethrow; // Re-throw the exception to handle it elsewhere if necessary
    }
  }

  // Hàm hintSearch nhận vào một chuỗi và trả về danh sách các đối tượng hintCharacter bắt đầu bằng chuỗi đó
  Future<List<HintCharacter>> hintSearch(String query) async {
    try {
      final db = await getDatabase();

      // Chuẩn hóa query bằng cách loại bỏ khoảng trắng và dấu gạch ngang
      String normalizedQuery = query.replaceAll(RegExp(r'[\s-]'), '').toLowerCase();

      List<HintCharacter> hintList = [];

      // Kiểm tra nếu query chứa ký tự bảng chữ cái tiếng Anh
      final englishAlphabet = RegExp(r'[a-zA-Z]');
      if (englishAlphabet.hasMatch(normalizedQuery)) {
        // Tìm các record mà cột pinyinQuery bắt đầu từ normalizedQuery
        final result = await db.query(
          'Words',
          where: 'REPLACE(REPLACE(LOWER(pinyinQuery), " ", ""), "-", "") LIKE ?',
          whereArgs: ['$normalizedQuery%'], // Tìm những từ có pinyinQuery bắt đầu với chuỗi normalizedQuery
          limit: 15, // Giới hạn số lượng kết quả trả về
        );

        // Chuyển đổi kết quả thành danh sách các đối tượng hintCharacter
        hintList = result.map((record) {
          return HintCharacter(
            hanzi: (record['word'] ?? '').toString(),
            pinyin: (record['pinyinQuery'] ?? '').toString(),
            hanViet: (record['hanviet'] ?? '').toString(),
            shortMeaning: (record['shortmeaning'] ?? '').toString(),
          );
        }).toList();
      } else {
        // Truy vấn tìm theo cột word nếu không chứa ký tự tiếng Anh
        final result = await db.query(
          'Words',
          where: 'word LIKE ?',
          whereArgs: ['$query%'], // Tìm những từ bắt đầu với chuỗi query
          limit: 15, // Giới hạn số lượng kết quả trả về
        );

        // Chuyển đổi kết quả thành danh sách các đối tượng hintCharacter
        hintList = result.map((record) {
          return HintCharacter(
            hanzi: (record['word'] ?? '').toString(),
            pinyin: (record['pinyinQuery'] ?? '').toString(),
            hanViet: (record['hanviet'] ?? '').toString(),
            shortMeaning: (record['shortmeaning'] ?? '').toString(),
          );
        }).toList();
      }

      // Nếu số lượng bản ghi nhỏ hơn hoặc bằng 1, tìm các bản ghi theo từng ký tự
      if (hintList.length <= 1) {
        final characters = query.split('');
        Set<HintCharacter> additionalRecords = {};

        for (String char in characters) {
          final additionalResult = await db.query(
            'Words',
            where: 'word = ?',
            whereArgs: [char],
          );

          additionalResult.forEach((record) {
            additionalRecords.add(
              HintCharacter(
                hanzi: (record['word'] ?? '').toString(),
                pinyin: (record['pinyinQuery'] ?? '').toString(),
                hanViet: (record['hanviet'] ?? '').toString(),
                shortMeaning: (record['shortmeaning'] ?? '').toString(),
              ),
            );
          });
        }

        hintList.addAll(additionalRecords);
      }

      // Sắp xếp danh sách kết quả theo chiều dài của trường 'word' nếu có nhiều hơn 1 bản ghi
      if (hintList.length > 1) {
        hintList.sort((a, b) {
          if (a.hanzi == query && b.hanzi != query) {
            return -1;
          }
          if (a.hanzi != query && b.hanzi == query) {
            return 1;
          }
          return a.hanzi.length.compareTo(b.hanzi.length);
        });
      }

      print('Data retrieved successfully:');
      return hintList;
    } catch (e) {
      print('Error occurred while searching: $e');
      return [];
    }
  }


  // Hàm getWord nhận vào một chuỗi và trả về đối tượng word
  Future<Word?> getWord(String searchWord) async {
    try {
      final db = await getDatabase();

      // Truy vấn cơ sở dữ liệu để tìm từ có trường 'word' trùng khớp
      final result = await db.query(
        'Words',
        where: 'word = ?',
        whereArgs: [searchWord],
        limit: 1, // Giới hạn chỉ lấy 1 bản ghi
      );

      if (result.isNotEmpty) {
        final record = result.first;

        // // In ra các trường để kiểm tra giá trị của chúng
        // print('Record found: $record');
        // print('ID: ${record['id']}');
        // print('Word: ${record['word']}');
        // print('Pinyin: ${record['pinyin']}');
        // print('Meaning: ${record['meaning']}');
        // print('Hanviet: ${record['hanviet']}');
        // print('Cannghia: ${record['cannghia']}');
        // print('Trainghia: ${record['trainghia']}');
        // print('Image: ${record['image']}');
        // print('ShortMeaning: ${record['shortmeaning']}');
        // print('HSK Level: ${record['hsk_level']}');

        // Chuyển đổi kết quả thành đối tượng Word
        return Word(
          id: record['id'] as int,
          word: record['word'] as String,
          pinyin: record['pinyin'] as String?,
          meaning: record['meaning'] != null ? List<String>.from(jsonDecode(record['meaning'] as String)) : null,
          hanviet: record['hanviet'] as String?,
          cannghia: record['cannghia'] != null ? List<String>.from(jsonDecode(record['cannghia'] as String)) : null,
          trainghia: record['trainghia'] != null ? List<String>.from(jsonDecode(record['trainghia'] as String)) : null,
          image: record['image'] as String?,
          shortMeaning: record['shortmeaning'] as String?,
          hskLevel: record['HSK_Level'] as String?,
        );
      } else {
        // Nếu không tìm thấy kết quả, trả về null
        return null;
      }
    } catch (e) {
      print('Error occurred while retrieving word: $e');
      return null; // Trả về null nếu có lỗi
    }
  }

}
