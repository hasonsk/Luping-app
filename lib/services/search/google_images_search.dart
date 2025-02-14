import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> fetchData(String input, int offset) async {
  // JSON object to send as query parameters
  final Map<String, dynamic> queryParams = {
    "q": input,
    "num": 9,
    "start": offset,
    "imgSize": "medium",
    "searchType": "image",
    "key": dotenv.env['API_KEY'],
    "cx": dotenv.env['CSE_ID']
  };

  // Convert queryParams to URI format
  final uri = Uri.https('https://www.googleapis.com', '/customsearch/v1', queryParams);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}
