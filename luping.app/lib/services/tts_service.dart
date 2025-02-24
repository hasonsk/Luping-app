import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

class TtsService {
  static final _logger = Logger();
  final AudioPlayer _audioPlayer = AudioPlayer();

  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  // Sanitize filename to remove invalid characters.
  String _sanitizeFilename(String text) {
    // Unicode range for common CJK Unified Ideographs (covers most Chinese characters)
    final chineseRegex = RegExp(r'[\u4E00-\u9FA5]');

    String sanitized = "";
    for (final char in text.toLowerCase().codeUnits) {
      // Iterate through Unicode code points
      final charStr = String.fromCharCode(char);
      if (RegExp(r'[a-z0-9]').hasMatch(charStr) ||
          chineseRegex.hasMatch(charStr)) {
        sanitized += charStr;
      } else {
        sanitized += "-";
      }
    }

    // Remove leading/trailing hyphens and collapse multiple hyphens
    sanitized = sanitized
        .replaceAll(RegExp(r'^-+|-+$'), '')
        .replaceAll(RegExp(r'-+'), '-');
    return sanitized;
  }

  Future<String> _getAudioFilePath(String text) async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDirectory = Directory('${directory.path}/audio');
    // Ensure the audio directory exists
    if (!await audioDirectory.exists()) {
      await audioDirectory.create(recursive: true);
    }
    final sanitizedFilename = _sanitizeFilename(text);
    return '${audioDirectory.path}/$sanitizedFilename.wav';
  }

  /// Fetches audio from the server.
  Future<Uint8List?> _fetchAudioFromServer(String text) async {
    final serverBaseUrl = dotenv.env['SERVER_BASE_URL'] ?? '';
    final url = Uri.parse('$serverBaseUrl/text-to-speech');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'text': text}),
          )
          .timeout(const Duration(seconds: 30)); // Increased timeout

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        _logger.e(
            'TTS API Error: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      _logger.e('Network Error fetching TTS: $e');
      return null;
    }
  }

  /// Stores the audio data to a local file.
  Future<void> _storeAudioFile(String text, Uint8List audioData) async {
    final filePath = await _getAudioFilePath(text);
    final file = File(filePath);
    await file.writeAsBytes(audioData, flush: true); // Ensure data is written
    _logger.i('Audio file saved to: $filePath');
  }

  /// Plays the audio for the given text.
  Future<void> playAudio(String text) async {
    final filePath = await _getAudioFilePath(text);
    final file = File(filePath);

    if (await file.exists()) {
      // Play from local file.
      _logger.i('Playing audio from local file: $filePath');
      try {
        await _audioPlayer.setFilePath(filePath);
        await _audioPlayer.play();
      } catch (e) {
        _logger.e('Error playing audio from file: $e');
        await file.delete();
        rethrow; // Re-throw to let the caller handle UI updates.
      }
    } else {
      // Fetch from the server and then play.
      _logger.i('Fetching audio from server for: $text');
      final audioData = await _fetchAudioFromServer(text);
      if (audioData != null) {
        await _storeAudioFile(text, audioData);
        // Play the audio directly after saving.
        final filePath = await _getAudioFilePath(text);
        await _audioPlayer.setFilePath(filePath);
        await _audioPlayer.play();
      } else {
        throw Exception('Failed to fetch audio from server.');
      }
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
