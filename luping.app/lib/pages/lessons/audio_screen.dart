import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/lesson.dart';

class AudioScreen extends StatelessWidget {
  final Lesson lesson;

  const AudioScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('File nghe', style: TextStyle(fontSize: 17)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        centerTitle: true,
        shadowColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Icon(Icons.book, color: Colors.green, size: 20),
                SizedBox(width: 10),
                Text(
                  'Bài ${lesson.index} : ${lesson.title}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: lesson.audioFiles.length,
                itemBuilder: (context, index) {
                  final audioFile = lesson.audioFiles[index];
                  return AudioListItem(
                    index: index + 1,
                    title: audioFile.title,
                    audioPath: audioFile.filePath,
                    isLast: index == lesson.audioFiles.length - 1, // Xác định phần tử cuối cùng
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
  final bool isLast; // Kiểm tra phần tử cuối

  const AudioListItem({
    Key? key,
    required this.index,
    required this.title,
    required this.audioPath,
    required this.isLast,
  }) : super(key: key);

  @override
  _AudioListItemState createState() => _AudioListItemState();
}

class _AudioListItemState extends State<AudioListItem> {
  late AudioPlayer _audioPlayer;
  static AudioPlayer? _currentlyPlayingPlayer;
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
        _currentlyPlayingPlayer = null;
      }
    } else {
      if (_currentlyPlayingPlayer != null && _currentlyPlayingPlayer != _audioPlayer) {
        await _currentlyPlayingPlayer!.pause();
      }
      await _audioPlayer.play();
      _currentlyPlayingPlayer = _audioPlayer;
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
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 0.5),
              ),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              '${widget.index}.',
              style: const TextStyle(color: Colors.black, fontSize: 13),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 15),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              SizedBox(width: 15),
              Text(
                '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                style: TextStyle(fontSize: 10),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.grey.withOpacity(0.3),
                    thumbColor: Colors.green,
                    overlayColor: Colors.green.withOpacity(0.2),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
                  ),
                  child: Slider(
                    value: _currentPosition.inSeconds.toDouble(),
                    min: 0,
                    max: _totalDuration.inSeconds.toDouble(),
                    onChanged: (value) async {
                      await _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
        SizedBox(height: 25),
        if (!widget.isLast) const Divider(), // Ẩn Divider nếu là phần tử cuối
        if (!widget.isLast) SizedBox(height: 15),
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
