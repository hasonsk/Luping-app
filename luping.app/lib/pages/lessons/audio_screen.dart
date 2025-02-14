import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/lesson.dart';

class AudioScreen extends StatelessWidget {
  final Lesson lesson;

  const AudioScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File nghe'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bài ${lesson.index} : ${lesson.title}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: lesson.audioFiles.length,
                itemBuilder: (context, index) {
                  final audioFile = lesson.audioFiles[index];
                  return AudioListItem(
                    index: index + 1,
                    title: audioFile.title,
                    audioPath: audioFile.filePath,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioListItem extends StatefulWidget {
  final int index;
  final String title;
  final String audioPath;

  const AudioListItem({
    Key? key,
    required this.index,
    required this.title,
    required this.audioPath,
  }) : super(key: key);

  @override
  _AudioListItemState createState() => _AudioListItemState();
}

class _AudioListItemState extends State<AudioListItem> {
  late AudioPlayer _audioPlayer;
  static AudioPlayer? _currentlyPlayingPlayer; // Tham chiếu đến AudioPlayer hiện tại
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setAsset(widget.audioPath).then((duration) {
      if (duration != null) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      if (_currentlyPlayingPlayer == _audioPlayer) {
        _currentlyPlayingPlayer = null; // Nếu dừng phát, đặt tham chiếu về null
      }
    } else {
      if (_currentlyPlayingPlayer != null && _currentlyPlayingPlayer != _audioPlayer) {
        await _currentlyPlayingPlayer!.pause(); // Dừng phát âm thanh hiện tại
      }
      await _audioPlayer.play();
      _currentlyPlayingPlayer = _audioPlayer; // Cập nhật tham chiếu tới audioPlayer hiện tại
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                '${widget.index}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: _togglePlayPause,
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.green,
              ),
            ),
            Expanded(
              child: Slider(
                value: _currentPosition.inSeconds.toDouble(),
                min: 0,
                max: _totalDuration.inSeconds.toDouble(),
                onChanged: (value) async {
                  await _audioPlayer.seek(Duration(seconds: value.toInt()));
                },
              ),
            ),
            Text(
              '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds % 60);
    return '$minutes:$seconds';
  }
}
