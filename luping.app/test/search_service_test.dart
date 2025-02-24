// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:luping/data/database_helper.dart';
import 'package:luping/services/search_service.dart';
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
      for (var hint in results) {
        print(
            'Hanzi: ${hint.hanzi}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanViet}, Meaning: ${hint.shortmeaning}');
      }
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
      for (var hint in results) {
        print(
            'Hanzi: ${hint.hanzi}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanViet}, Meaning: ${hint.shortmeaning}');
      }
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
      for (var hint in results) {
        print(
            'Hanzi: ${hint.hanzi}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanViet}, Meaning: ${hint.shortmeaning}');
      }
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
      for (var hint in results) {
        print(
            'Hanzi: ${hint.hanzi}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanViet}, Meaning: ${hint.shortmeaning}');
      }
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

      print(
          'Word: ${word?.word}, Pinyin: ${word?.pinyin}, HanViet: ${word?.hanviet}, Meaning: ${word?.meaning}, shortmeaning: ${word?.shortmeaning}');

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

  group('Test getStoryHint', () {
    test('Query "你好" nên trả về HintStory cho cả hai ký tự', () async {
      final results = await searchService.getStoryHint("你好");

      // Debug prints
      print("Results for '你好':");
      for (var hint in results) {
        print(
            "Character: ${hint.character}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanviet}, Meaning: ${hint.meaning}");
      }

      expect(results.length, 2, reason: "Nên có 2 HintStory");
      expect(results[0].character, "你", reason: "Ký tự đầu tiên phải là 你");
      expect(results[1].character, "好", reason: "Ký tự thứ hai phải là 好");
    });

    test('Query "你" nên trả về HintStory cho ký tự 你', () async {
      final results = await searchService.getStoryHint("你");
      expect(results.length, 1, reason: "Nên có 1 HintStory");
      expect(results[0].character, "你", reason: "Ký tự phải là 你");
    });

    test('Query "hello" không chứa ký tự Hán nên trả về danh sách rỗng',
        () async {
      final results = await searchService.getStoryHint("hello");
      expect(results, isEmpty, reason: "Nên trả về danh sách rỗng");
    });

    test('Query "" (chuỗi rỗng) nên trả về danh sách rỗng', () async {
      final results = await searchService.getStoryHint("");
      expect(results, isEmpty, reason: "Nên trả về danh sách rỗng");
    });

    test('Query "你好世界" nên trả về đúng thứ tự các HintStory', () async {
      final results = await searchService.getStoryHint("你好世界");

      // Debug prints (optional, but good for seeing what's going on)
      print("Results for '你好世界':");
      for (var hint in results) {
        print(
            "Character: ${hint.character}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanviet}, Meaning: ${hint.meaning}");
      }

      expect(results.length, 4, reason: "Nên có 4 HintStory");
      expect(results[0].character, "你", reason: "Ký tự đầu tiên phải là 你");
      expect(results[1].character, "好", reason: "Ký tự thứ hai phải là 好");
      expect(results[2].character, "世", reason: "Ký tự thứ ba phải là 世");
      expect(results[3].character, "界", reason: "Ký tự thứ tư phải là 界");
    });

    test('Query chứa ký tự Hán không có trong database nên bỏ qua', () async {
      final results =
          await searchService.getStoryHint("你xyz好"); // 'xyz' không phải Hán tự
      // Debug prints (optional)
      print("Results for '你xyz好':");
      for (var hint in results) {
        print(
            "Character: ${hint.character}, Pinyin: ${hint.pinyin}, HanViet: ${hint.hanviet}, Meaning: ${hint.meaning}");
      }

      expect(results.length, 2, reason: "Nên có 2 HintStory (bỏ qua xyz)");
      expect(results[0].character, "你", reason: "Ký tự đầu tiên phải là 你");
      expect(results[1].character, "好", reason: "Ký tự thứ hai phải là 好");
    });
  });

  group('Test getStoryDetail', () {
    test('Get story detail for "你" should return correct data', () async {
      final story = await searchService.getStoryDetails('你');

      print("Story Details for '你':");
      print("Character: ${story?.character}");
      print("Pinyin: ${story?.pinyin}");
      print("HanViet: ${story?.hanviet}");
      print("Meaning: ${story?.meaning}");
      print("Bothu: ${story?.bothu}");
      print("Lucthu: ${story?.lucthu}");
      print("Sonet: ${story?.sonet}");
      print("Bothanhphan: ${story?.bothanhphan}");
      print("Image: ${story?.image}");
      print("Mnemonic V Seperate: ${story?.mnemonic_v_seperate}");
      print("Mnemonic V Content: ${story?.mnemonic_v_content}");
      print("Mnemonic V Media: ${story?.mnemonic_v_media}");
      print("Mnemonic C Content: ${story?.mnemonic_c_content}");
      print("Mnemonic C Media: ${story?.mnemonic_c_media}");
      print("Mnemonic K Content: ${story?.mnemonic_k_content}");
      print("Mnemonic K Media: ${story?.mnemonic_k_media}");
      print("MP3: ${story?.mp3}");

      expect(story, isNotNull, reason: 'Should return a Story object');
      expect(story?.character, '你', reason: 'Character should be 你');
      expect(story?.pinyin, isNotNull, reason: 'Pinyin should not be null');
      expect(story?.meaning, isA<List<String>>(),
          reason: 'Meaning should be a list of strings');
    });

    test('Get story detail for non-existent character should return null',
        () async {
      final story =
          await searchService.getStoryDetails('龘'); // A rare character
      expect(story, isNull,
          reason: 'Should return null for non-existent story');
    });

    test('Get story detail with empty string should return null', () async {
      final story = await searchService.getStoryDetails('');
      expect(story, isNull,
          reason: "Should return null for empty string input");
    });
  });

  group('Test fetchWordList', () {
    test('Get WordList for "焵, 涙" should return correct data', () async {
      final wordList = await searchService.fetchWordList(['焵', 'abc']);

      if (wordList == null) {
        print('wordList empty');
        return;
      }

      for (var word in wordList) {
        print("Word Details for '${word.word}':");
        print("Pinyin: ${word.pinyin}");
        print("Meaning: ${word.meaning}");
        print("HanViet: ${word.hanviet}");
        print("Cannghia: ${word.cannghia}");
        print("Trainghia: ${word.trainghia}");
        print("Image: ${word.image}");
        print("Short meaning: ${word.shortmeaning}");
        print('');
      }
    });

    test('Get WordList for "luping" should return null', () async {
      final wordList = await searchService.fetchWordList(['luping']);

      if (wordList == null) {
        print('wordList empty');
        return;
      }

      for (var word in wordList) {
        print("Word Details for '${word.word}':");
      }
    });
  });
}
