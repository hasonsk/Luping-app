import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../domain/repositories/speech_repository.dart';

class SpeechRepositoryImpl implements SpeechRepository {
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  Future<String> startRecording() async {
    String recognizedText = "";
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(onResult: (result) {
        recognizedText = result.recognizedWords;
      });
      await Future.delayed(const Duration(seconds: 5));
      _speech.stop();
    }
    return recognizedText;
  }
}
