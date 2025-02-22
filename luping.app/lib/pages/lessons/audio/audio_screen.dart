import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../../../models/lesson.dart';

class AudioScreen extends StatelessWidget {
  final Lesson lesson;

  const AudioScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Bài ${lesson.lessonId} / File nghe', style: const TextStyle(fontSize: 17)),
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lesson.lessonListening.length,
                itemBuilder: (context, index) {
                  final audioFile = lesson.lessonListening[index];
                  return AudioListItem(
                    index: index + 1,
                    title: audioFile.title,
                    audioPath: _convertGoogleDriveLink(audioFile.filePath),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _convertGoogleDriveLink(String url) {
    RegExp regExp = RegExp(r'https://drive\.google\.com/file/d/([^/]+)/view');
    Match? match = regExp.firstMatch(url);
    if (match != null) {
      String fileId = match.group(1)!;
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }
    return url;
  }
}

class AudioListItem extends StatefulWidget {
  final int index;
  final String title;
  final String audioPath;

  const AudioListItem({
    super.key,
    required this.index,
    required this.title,
    required this.audioPath,
  });

  @override
  _AudioListItemState createState() => _AudioListItemState();
}

class _AudioListItemState extends State<AudioListItem> {
  late AudioPlayer _audioPlayer;
  static AudioPlayer? _currentlyPlayingPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isInitialized = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.audioPath))).then((duration) {
      if (duration != null) {
        setState(() {
          _totalDuration = duration;
          _isInitialized = true;
        });
      }
    }).catchError((_) {
      setState(() {
        _isInitialized = true; // Tránh loading mãi nếu lỗi
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
      // Nếu bài này đang phát, thì dừng nó
      await _audioPlayer.pause();
      if (_currentlyPlayingPlayer == _audioPlayer) {
        _currentlyPlayingPlayer = null;
      }
    } else {
      // Nếu đang có bài khác phát, thì dừng nó
      if (_currentlyPlayingPlayer != null && _currentlyPlayingPlayer != _audioPlayer) {
        await _currentlyPlayingPlayer!.stop();
      }

      // Cập nhật player hiện tại
      _currentlyPlayingPlayer = _audioPlayer;

      if (!_isInitialized) {
        setState(() => _isLoading = true);
        try {
          await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.audioPath)));
          _isInitialized = true;
        } catch (_) {
          // Xử lý lỗi nếu cần
        }
        setState(() => _isLoading = false);
      }

      await _audioPlayer.play();
    }

    setState(() => _isPlaying = !_isPlaying);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text('${widget.index}. ${widget.title}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            IconButton(
              onPressed: _togglePlayPause,
              icon: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.green.withOpacity(0.3),
            thumbColor: Colors.green,
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: _currentPosition.inSeconds.toDouble(),
            min: 0,
            max: _totalDuration.inSeconds.toDouble(),
            onChanged: (value) async {
              await _audioPlayer.seek(Duration(seconds: value.toInt()));

              // Nếu chưa phát bài này, thì bật lên và dừng bài cũ
              if (!_isPlaying) {
                if (_currentlyPlayingPlayer != null && _currentlyPlayingPlayer != _audioPlayer) {
                  await _currentlyPlayingPlayer!.stop();
                }

                await _audioPlayer.play();
                _currentlyPlayingPlayer = _audioPlayer;
                setState(() => _isPlaying = true);
              }
            },
          ),
        ),
      ],
    );
  }
}
