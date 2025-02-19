import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  static final stt.SpeechToText _speech = stt.SpeechToText();

  static Future<String> startRecording() async {
    String recognizedText = "";
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(onResult: (result) {
        recognizedText = result.recognizedWords;
      });
      await Future.delayed(Duration(seconds: 5)); // Ghi âm trong 5 giây
      _speech.stop();
    }
    return recognizedText;
  }
}