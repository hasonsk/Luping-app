import 'dart:convert';
import 'package:http/http.dart' as http;

class Handwriting {
  Handwriting({this.width, this.height, this.language = 'zh_TW'});

  final double? width;
  final double? height;
  final String language;

  Future<void> recognize(List<List<int>> trace, Map<String, dynamic>? options, Function(List<dynamic>?, Error?) callback) async {
    options ??= {}; // Đặt mặc định cho options nếu là null

    final data = jsonEncode({
      "options": "enable_pre_space",
      "requests": [
        {
          "writing_guide": {
            "writing_area_width": options['width'] ?? width,
            "writing_area_height": options['height'] ?? height,
          },
          "ink": trace,
          "language": options['language'] ?? language,
        }
      ]
    });

    try {
      final response = await http.post(
        Uri.parse("https://www.google.com.tw/inputtools/request?ime=handwriting&app=mobilesearch&cs=1&oe=UTF-8"),
        headers: {"Content-Type": "application/json"},
        body: data,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.length == 1) {
          callback(null, Error()); // Xử lý lỗi
        } else {
          var results = responseData[1][0][1];

          // Kiểm tra nếu options không null và khóa numOfWords tồn tại
          if (options['numOfWords'] != null) {
            results = results.where((result) => result.length == options!['numOfWords']).toList();
          }

          // Kiểm tra nếu options không null và khóa numOfReturn tồn tại
          if (options['numOfReturn'] != null) {
            results = results.take(options['numOfReturn']).toList();
          }

          callback(results, null);
        }
      } else {
        switch (response.statusCode) {
          case 403:
            callback(null, Error()); // Access denied
            break;
          case 503:
            callback(null, Error()); // Can't connect to recognition server
            break;
          default:
            callback(null, Error()); // Lỗi khác
            break;
        }
      }
    } catch (e) {
      callback(null, Error()); // Xử lý ngoại lệ
    }
  }
}

void main() {
  var handwriting = Handwriting(width: 300, height: 200);
  var trace = [
    [123, 120, 117, 113, 110, 106, 103, 100, 97, 94, 92, 90, 89, 89, 89, 89, 90, 93, 98, 105, 112, 120, 128, 137, 145, 153, 159, 165, 170, 174, 177, 180, 151, 144, 136, 130, 125, 120, 116, 112, 108, 111, 120, 129, 139, 150, 160, 171, 181, 191, 243, 245, 246, 247, 247, 246, 245, 242, 238, 235, 232, 230, 228, 227, 227, 227, 227, 227, 227, 229, 231, 234, 237, 239, 242, 244, 246, 248, 249, 249, 249, 247, 245, 242, 239, 236, 232, 228, 237, 246, 255, 263, 270, 276],
    [114, 123, 132, 142, 153, 163, 172, 180, 188, 195, 200, 204, 207, 209, 210, 211, 211, 212, 213, 214, 216, 217, 220, 222, 225, 229, 232, 236, 239, 242, 243, 245, 194, 204, 215, 224, 232, 238, 242, 245, 246, 155, 153, 150, 146, 143, 140, 136, 133, 130, 120, 121, 123, 125, 127, 130, 134, 139, 144, 148, 151, 154, 155, 157, 158, 158, 159, 160, 161, 163, 166, 168, 171, 174, 178, 182, 188, 193, 200, 206, 213, 220, 225, 231, 236, 239, 242, 201, 201, 201, 201, 202, 203, 204]
  ];

  var options = {
    'language': 'zh_TW',
    'numOfReturn': 5,
    'numOfWords': 2, // Có thể thay đổi tùy thuộc vào yêu cầu
  };

  handwriting.recognize(trace, options, (results, error) {
    if (error != null) {
      print("Error: ${error.toString()}");
    } else {
      print("Recognition results: ${results.toString()}");
    }
  });
}
