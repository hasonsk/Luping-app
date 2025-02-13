import 'package:hanjii/models/word.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../data/database_helper.dart';
import '../models/hint_character.dart';

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
}
