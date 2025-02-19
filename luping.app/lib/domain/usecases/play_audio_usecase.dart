import '../repositories/audio_repository.dart';

class PlayAudioUseCase {
  final AudioRepository repository;

  PlayAudioUseCase(this.repository);

  void execute(String filePath) {
    repository.playAudio(filePath);
  }
}
