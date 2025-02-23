import 'package:luping/models/hint_story.dart';
import 'package:luping/models/story.dart';
import 'package:luping/models/word.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../data/database_helper.dart';
import '../models/hint_character.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/sentence.dart';

class SearchService {
  static const int MAX_RESULTS = 15;

  static final logger = Logger();

  late Future<Database> _db;

  SearchService() {
    _db = DatabaseHelper.getDatabase();
  }

  Future<List<HintCharacter>> hintSearch(String query) async {
    try {
      final db = await _db;

      // 1. Chuẩn hóa input: loại bỏ ZWSP và khoảng trắng thừa
      String normalizeText(String text) {
        return text
            .replaceAll('\u200B', '')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
      }

      final normalizedQuery = normalizeText(query.toLowerCase());

      // Tách query thành các token, loại bỏ token rỗng
      final tokens =
          normalizedQuery.split(" ").where((t) => t.isNotEmpty).toList();
      if (tokens.isEmpty) return [];

      // Chuỗi tìm kiếm đầy đủ không có khoảng trắng (ví dụ "ni hao" -> "nihao")
      // final normalizedFull = normalizedQuery.replaceAll(" ", "");

      // 2. Tạo bonus exact match cho từng trường
      // Mỗi trường nếu khớp chính xác với chuỗi tìm kiếm không khoảng trắng sẽ nhận bonus cao
      final String exactBonusClause = """
      (
        CASE WHEN REPLACE(word, '​', ' ') = '$normalizedQuery' THEN 100 ELSE 0 END +
        CASE WHEN REPLACE(pinyinQuery, '​', ' ') = '$normalizedQuery' THEN 100 ELSE 0 END +
        CASE WHEN REPLACE(meaning, '​', ' ') = '$normalizedQuery' THEN 100 ELSE 0 END +
        CASE WHEN REPLACE(hanviet, '​', ' ') = '$normalizedQuery' THEN 100 ELSE 0 END
      )
      """;

      final String partialBonusClause = """
      (
        CASE WHEN REPLACE(word, '​', ' ') LIKE '%$normalizedQuery%' THEN 50 ELSE 0 END +
        CASE WHEN REPLACE(pinyinQuery, '​', ' ') LIKE '%$normalizedQuery%' THEN 50 ELSE 0 END +
        CASE WHEN REPLACE(meaning, '​', ' ') LIKE '%$normalizedQuery%' THEN 50 ELSE 0 END +
        CASE WHEN REPLACE(hanviet, '​', ' ') LIKE '%$normalizedQuery%' THEN 50 ELSE 0 END
      )
      """;

      // 3. Tính điểm cho mỗi token trong mỗi trường
      // Mỗi trường được tính theo 3 mức độ với điểm số giảm dần:
      // - Exact match: nếu trường khớp chính xác với token, điểm số cao nhất
      // - Prefix match: nếu trường bắt đầu bằng token, điểm số trung bình
      // - Substring match: nếu trường chứa token, điểm số thấp nhất
      final List<String> scoreParts = tokens.map((token) => """
      (
        CASE
          WHEN REPLACE(word, '​', '') = '$token' THEN 20
          WHEN REPLACE(word, '​', '') LIKE '$token%' THEN 15
          WHEN REPLACE(word, '​', '') LIKE '%$token%' THEN 10
          ELSE 0
        END
        +
        CASE
          WHEN REPLACE(pinyinQuery, '​', '') = '$token' THEN 16
          WHEN REPLACE(pinyinQuery, '​', '') LIKE '$token%' THEN 12
          WHEN REPLACE(pinyinQuery, '​', '') LIKE '%$token%' THEN 8
          ELSE 0
        END
        +
        CASE
          WHEN REPLACE(meaning, '​', '') = '$token' THEN 12
          WHEN REPLACE(meaning, '​', '') LIKE '$token%' THEN 9
          WHEN REPLACE(meaning, '​', '') LIKE '%$token%' THEN 6
          ELSE 0
        END
        +
        CASE
          WHEN REPLACE(hanviet, '​', '') = '$token' THEN 10
          WHEN REPLACE(hanviet, '​', '') LIKE '$token%' THEN 7
          WHEN REPLACE(hanviet, '​', '') LIKE '%$token%' THEN 5
          ELSE 0
        END
      )
      """).toList();

      final String tokenScoreClause = scoreParts.join(" + ");

      // Tổng điểm là tổng bonus exact match cộng với điểm từng token
      final String totalScoreClause =
          "(\n$exactBonusClause + $partialBonusClause + $tokenScoreClause\n)";

      // 4. Xây dựng WHERE clause chỉ với các trường: word, pinyinQuery, meaning, hanviet
      final List<String> conditions = [];
      for (final token in tokens) {
        conditions.addAll([
          """REPLACE(word, '​', '') LIKE '%$token%'""",
          """REPLACE(pinyinQuery, '​', '') LIKE '%$token%'""",
          """REPLACE(meaning, '​', '') LIKE '%$token%'""",
          """REPLACE(hanviet, '​', '') LIKE '%$token%'"""
        ]);
      }
      final String whereClause = conditions.join("\n      OR ");

      // 5. Tạo câu truy vấn SQL với proper formatting
      final String sql = """
      SELECT
        *,
        $totalScoreClause AS relevance
      FROM Words
      WHERE
        $whereClause
      ORDER BY relevance DESC
      LIMIT $MAX_RESULTS
      """;

      // 6. Thực thi truy vấn
      final List<Map<String, dynamic>> results = await db.rawQuery(sql);
      return results.map((row) => HintCharacter.fromMap(row)).toList();
    } catch (e) {
      logger.e("Error in hintSearch: $e");
      return [];
    }
  }

  // Hàm getWord nhận vào một chuỗi và trả về đối tượng word
  Future<Word?> getWord(String searchWord) async {
    try {
      final db = await _db;

      final result = await db.query(
        'Words',
        where: 'word = ?',
        whereArgs: [searchWord],
        limit: 1,
      );

      if (result.isNotEmpty) {
        final record = result.first;
        return Word.fromMap(record);
      } else {
        return null;
      }
    } catch (e) {
      logger.e('Error occurred while retrieving word: $e');
      return null;
    }
  }

  Future<List<String>?> getImage(String input, int offset) async {
    /*
    Fetch images from Google Image via Google Custom Search API
    and return a list of image URLs.
  */

    // Lấy API Key & CSE ID, kiểm tra null
    final apiKey = dotenv.env['API_KEY'] ?? "";
    final cseId = dotenv.env['CSE_ID'] ?? "";
    if (apiKey.isEmpty || cseId.isEmpty) {
      throw Exception("API_KEY hoặc CSE_ID chưa được cấu hình!");
    }

    // Tham số truy vấn API
    final Map<String, String> queryParams = {
      "q": input,
      "num": "9",
      "start": offset.toString(),
      "imgSize": "medium",
      "searchType": "image",
      "key": apiKey,
      "cx": cseId
    };

    // Tạo URI chính xác
    final uri =
        Uri.https('www.googleapis.com', '/customsearch/v1', queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('items')) {
          // Lọc ra danh sách link hình ảnh từ kết quả API
          List<String> imageLinks =
              List<String>.from(data['items'].map((item) => item['link']));

          return imageLinks;
        } else {
          logger.w("Không tìm thấy hình ảnh nào.");
          return [];
        }
      } else {
        throw Exception('Lỗi API: ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Lỗi trong getImage: $e");
      return null;
    }
  }

  Future<List<Sentence>> getSentence(String searchWord) async {
    try {
      final db = await _db;

      // sw
      // 1. Chuẩn hóa input: loại bỏ ZWSP và khoảng trắng thừa
      String normalizeText(String text) {
        return text
            .replaceAll('\u200B', '')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
      }

      final normalizedQuery = normalizeText(searchWord.toLowerCase());

      // Tách query thành các token, loại bỏ token rỗng
      final tokens =
          normalizedQuery.split(" ").where((t) => t.isNotEmpty).toList();
      if (tokens.isEmpty) return [];

      // 2. Tạo bonus exact match cho từng trường
      // Mỗi trường nếu khớp chính xác với chuỗi tìm kiếm không khoảng trắng sẽ nhận bonus cao
      final String exactBonusClause = """
      (
        CASE WHEN REPLACE(sentence, '​', ' ') = '$normalizedQuery' THEN 100 ELSE 0 END +
        CASE WHEN REPLACE(pinyin, '​', ' ') = '$normalizedQuery' THEN 100 ELSE 0 END +
        CASE WHEN REPLACE(meaning, '​', ' ') = '$normalizedQuery' THEN 100 ELSE 0 END +
        CASE WHEN REPLACE(searchquery, '​', ' ') = '$normalizedQuery' THEN 150 ELSE 0 END
      )
      """;

      final String partialBonusClause = """
      (
        CASE WHEN REPLACE(sentence, '​', ' ') LIKE '%$normalizedQuery%' THEN 50 ELSE 0 END +
        CASE WHEN REPLACE(pinyin, '​', ' ') LIKE '%$normalizedQuery%' THEN 50 ELSE 0 END +
        CASE WHEN REPLACE(meaning, '​', ' ') LIKE '%$normalizedQuery%' THEN 50 ELSE 0 END +
        CASE WHEN REPLACE(searchquery, '​', ' ') LIKE '%$normalizedQuery%' THEN 100 ELSE 0 END
      )
      """;

      // 3. Tính điểm cho mỗi token trong mỗi trường
      // Mỗi trường được tính theo 3 mức độ với điểm số giảm dần:
      // - Exact match: nếu trường khớp chính xác với token, điểm số cao nhất
      // - Prefix match: nếu trường bắt đầu bằng token, điểm số trung bình
      // - Substring match: nếu trường chứa token, điểm số thấp nhất
      final List<String> scoreParts = tokens.map((token) => """
      (
        CASE
          WHEN REPLACE(sentence, '​', '') = '$token' THEN 20
          WHEN REPLACE(sentence, '​', '') LIKE '$token%' THEN 15
          WHEN REPLACE(sentence, '​', '') LIKE '%$token%' THEN 10
          ELSE 0
        END
        +
        CASE
          WHEN REPLACE(pinyin, '​', '') = '$token' THEN 16
          WHEN REPLACE(pinyin, '​', '') LIKE '$token%' THEN 12
          WHEN REPLACE(pinyin, '​', '') LIKE '%$token%' THEN 8
          ELSE 0
        END
        +
        CASE
          WHEN REPLACE(meaning, '​', '') = '$token' THEN 12
          WHEN REPLACE(meaning, '​', '') LIKE '$token%' THEN 9
          WHEN REPLACE(meaning, '​', '') LIKE '%$token%' THEN 6
          ELSE 0
        END
        +
        CASE
          WHEN REPLACE(searchquery, '​', '') = '$token' THEN 30
          WHEN REPLACE(searchquery, '​', '') LIKE '$token%' THEN 25
          WHEN REPLACE(searchquery, '​', '') LIKE '%$token%' THEN 20
          ELSE 0
        END
      )
      """).toList();

      final String tokenScoreClause = scoreParts.join(" + ");

      // Tổng điểm là tổng bonus exact match cộng với điểm từng token
      final String totalScoreClause =
          "(\n$exactBonusClause + $partialBonusClause + $tokenScoreClause\n)";

      // 4. Xây dựng WHERE clause chỉ với các trường: word, pinyinQuery, meaning, hanviet
      final List<String> conditions = [];
      for (final token in tokens) {
        conditions.addAll([
          """REPLACE(searchquery, '​', '') LIKE '%$token%'""",
          """REPLACE(pinyin, '​', '') LIKE '%$token%'""",
          """REPLACE(meaning, '​', '') LIKE '%$token%'""",
          """REPLACE(searchquery, '​', '') LIKE '%$token%'"""
        ]);
      }
      final String whereClause = conditions.join("\n      OR ");

      // 5. Tạo câu truy vấn SQL với proper formatting
      final String sql = """
      SELECT
        *,
        $totalScoreClause AS relevance
      FROM Sentences
      WHERE
        $whereClause
      ORDER BY relevance DESC
      LIMIT $MAX_RESULTS
      """;
      // 6. Thực thi truy vấn
      final List<Map<String, dynamic>> results = await db.rawQuery(sql);
      return results.map((row) => Sentence.fromMap(row)).toList();
    } catch (e) {
      logger.e('Error occurred while retrieving sentence: $e');
      return [];
    }
  }

  Future<List<HintStory>> getStoryHint(String query) async {
    try {
      final db = await _db;
      // 1. Lọc bỏ các ký tự không phải chữ Hán
      final hanziQuery =
          query.replaceAll(RegExp(r'[^\p{Script=Han}]', unicode: true), '');

      if (hanziQuery.isEmpty) {
        return [];
      }

      final uniqueHanziQuery = hanziQuery.split('').toSet().join('');

      // 2. Tạo danh sách các placeholder và các giá trị tương ứng cho truy vấn
      final placeholders = List.filled(uniqueHanziQuery.length, '?').join(',');
      final characters = uniqueHanziQuery.split('');

      // 3. Truy vấn cơ sở dữ liệu, bao gồm trường 'image'
      final results = await db.query(
        'Storys',
        columns: [
          'id',
          'character',
          'pinyin',
          'hanviet',
          'meaning',
          'image'
        ], // Cập nhật ở đây
        where: 'character IN ($placeholders)',
        whereArgs: characters,
      );

      // 4. Tạo danh sách HintStory
      final List<HintStory> hintStories = [];
      for (final char in characters) {
        // Tìm story có character khớp với ký tự hiện tại
        final storyMap = results.firstWhere(
          (map) => map['character'] == char,
          orElse: () => {}, // Return empty map if no match
        );

        if (storyMap.isNotEmpty) {
          hintStories.add(HintStory.fromMap(storyMap));
        }
      }

      return hintStories;
    } catch (e) {
      logger.e("Error in getStoryHint: $e");
      return [];
    }
  }

  Future<Story?> getStoryDetails(String character) async {
    try {
      final db = await _db;
      print("🔍 Đang tìm kiếm story với character: $character");

      final results = await db.query(
        'Storys',
        columns: null,
        where: 'character = ?',
        whereArgs: [character],
      );

      if (results.isNotEmpty) {
        final story = Story.fromMap(results.first);
        print(
            "✅ Story tìm thấy: ${story.character}, ${story.pinyin}, ${story.mnemonic_c_media}");
        return story;
      }

      print("⚠️ Không tìm thấy story nào cho character: $character");
      return null;
    } catch (e) {
      logger.e("❌ Lỗi trong getStoryDetails: $e");
      return null;
    }
  }

  Future<List<Word>?> fetchWordList(List<String> wordList) async {
    print(wordList);
    try {
      final db = await _db;

      // sw
      // 1. Chuẩn hóa input: loại bỏ ZWSP và khoảng trắng thừa
      String normalizeText(String text) {
        return text
            .replaceAll('\u200B', '')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
      }

      if (wordList.isEmpty) throw Exception('Empty wordList');

      for (int i = 0; i < wordList.length; i++) {
        wordList[i] = normalizeText(wordList[i]);
      }

      String generateWhereClause(List<String> wordList) {
        String formattedWords = wordList.map((word) => "'$word'").join(', ');
        return "WHERE word IN ($formattedWords)";
      }

      final String whereClause = generateWhereClause(wordList);

      final String sql = """
      SELECT
        *
      FROM Words $whereClause
      """;

      // 6. Thực thi truy vấn
      final List<Map<String, dynamic>> results = await db.rawQuery(sql);
      return results.map((row) => Word.fromMap(row)).toList();
    } catch (e) {
      logger.e('Error occurred while fetching word list: $e');
      return [];
    }
  }
}
