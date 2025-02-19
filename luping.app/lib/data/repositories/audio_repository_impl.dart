import '../../services/audio_service.dart';
import '../../domain/repositories/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioService _audioService = AudioService();

  @override
  Future<void> playAudio(String filePath) async {
    await _audioService.playAudio(filePath);
  }
}
