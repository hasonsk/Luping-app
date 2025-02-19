import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAudio(String filePath) async {
    try {
      await _audioPlayer.stop(); // Dừng âm thanh nếu đang phát
      await _audioPlayer.play(AssetSource(filePath)); // Phát âm thanh từ URL
    } catch (e) {
      print("Lỗi phát âm thanh: $e");
    }
  }
}
