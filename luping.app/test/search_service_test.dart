import 'package:flutter_test/flutter_test.dart';
import 'package:hanjii/data/database_helper.dart';
import 'package:hanjii/services/search_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize Flutter binding first
  TestWidgetsFlutterBinding.ensureInitialized();

  late SearchService searchService;

  // Initialize sqflite_ffi before all tests
  setUpAll(() async {
    // Initialize FFI
    sqfliteFfiInit();
    // Set the database factory
    databaseFactory = databaseFactoryFfi;

    await DatabaseHelper.ensureDatabase();
    searchService = SearchService();
  });

  group('Test hintSearch', () {
    test('Query "ni hao" trả về kết quả chứa từ "你好"', () async {
      final results = await searchService.hintSearch("ni hao");

      // Debug print
      print('\n=== Results for "ni hao" search ===');
      results.forEach((hint) => print(
          'Hanzi: ${hint.hanzi}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanViet}, Meaning: ${hint.shortMeaning}'));
      print('Total results: ${results.length}\n');

      expect(results, isNotEmpty,
          reason: "Kết quả không được rỗng với query 'ni hao'");

      // Giả sử trong DB có từ "你好"
      final match = results.firstWhere((item) => item.hanzi == "你好",
          orElse: () =>
              throw TestFailure("Không tìm thấy từ '你好' trong kết quả"));
      expect(match, isNotNull, reason: "Không tìm thấy từ '你好' trong kết quả");
    });

    test('Query "你" trả về kết quả chứa từ "你好"', () async {
      final results = await searchService.hintSearch("你");

      // Debug print
      print('\n=== Results for "你" search ===');
      results.forEach((hint) => print(
          'Hanzi: ${hint.hanzi}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanViet}, Meaning: ${hint.shortMeaning}'));
      print('Total results: ${results.length}\n');

      expect(results, isNotEmpty,
          reason: "Kết quả không được rỗng với query '你'");

      // Giả sử trong DB có từ "你好"
      final match = results.firstWhere((item) => item.hanzi == "你好",
          orElse: () =>
              throw TestFailure("Không tìm thấy từ '你好' trong kết quả"));
      expect(match, isNotNull, reason: "Không tìm thấy từ '你好' trong kết quả");
    });

    test('Query "hao" trả về kết quả phù hợp', () async {
      final results = await searchService.hintSearch("hao");

      // Debug print
      print('\n=== Results for "hao" search ===');
      results.forEach((hint) => print(
          'Hanzi: ${hint.hanzi}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanViet}, Meaning: ${hint.shortMeaning}'));
      print('Total results: ${results.length}\n');

      expect(results, isNotEmpty,
          reason: "Kết quả không được rỗng với query 'hao'");

      // Nếu từ "嚆" là match tốt nhất thì nên xuất hiện đầu tiên
      expect(results.first.hanzi, equals("嚆"),
          reason: "Từ '嚆' nên xuất hiện đầu tiên với query 'hao'");
    });

    test('Query "xin chào" trả về kết quả chứa từ "你好"', () async {
      final results = await searchService.hintSearch("xin chào");

      // Debug print
      print('\n=== Results for "xin chào" search ===');
      results.forEach((hint) => print(
          'Hanzi: ${hint.hanzi}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanViet}, Meaning: ${hint.shortMeaning}'));
      print('Total results: ${results.length}\n');

      expect(results, isNotEmpty,
          reason: "Kết quả không được rỗng với query 'xin chào'");

      // Giả sử trong DB có từ "你好"
      final match = results.firstWhere((item) => item.hanzi == "你好",
          orElse: () =>
              throw TestFailure("Không tìm thấy từ '你好' trong kết quả"));
      expect(match, isNotNull, reason: "Không tìm thấy từ '你好' trong kết quả");
    });

    test('Query không tồn tại trả về danh sách rỗng', () async {
      final results = await searchService.hintSearch("xyz");
      expect(results, isEmpty,
          reason: "Không nên có kết quả với query không tồn tại");
    });
  });

  group('Test getWord', () {
    test("Get word '你好' should return the right word", () async {
      final word = await searchService.getWord('你好');

      print('Word: ${word?.word}, Pinyin: ${word?.pinyin}, HanViet: ${word?.hanviet}, Meaning: ${word?.meaning}, ShortMeaning: ${word?.shortMeaning}');

      expect(word, isNotNull, reason: "Không tìm thấy từ '你好'");
      expect(word?.word, equals('你好'));
    });

    test("Get word with invalid character should return null", () async {
      final word = await searchService.getWord('xyz');
      expect(word, isNull, reason: "Should return null for non-existent word");
    });

    test("Get word '我' should return correct data", () async {
      final word = await searchService.getWord('我');
      expect(word, isNotNull, reason: "Không tìm thấy từ '我'");
      expect(word?.word, equals('我'));
      expect(word?.pinyin, isNotNull);
      expect(word?.meaning, isA<List<String>>());
      expect(word?.hanviet, isNotNull);
      expect(word?.cannghia, isA<List<String>>());
      expect(word?.trainghia, isA<List<String>>());
    });

    test("Get word with empty string should return null", () async {
      final word = await searchService.getWord('');
      expect(word, isNull, reason: "Should return null for empty string");
    });

    test("Get word with spaces should return null", () async {
      final word = await searchService.getWord('  ');
      expect(word, isNull, reason: "Should return null for whitespace string");
    });
  });
}
