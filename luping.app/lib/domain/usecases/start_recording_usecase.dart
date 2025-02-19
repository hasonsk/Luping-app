import '../repositories/speech_repository.dart';

class StartRecordingUseCase {
  final SpeechRepository repository;

  StartRecordingUseCase(this.repository);

  Future<String> execute() async {
    return await repository.startRecording();
  }
}
