import 'package:flutter/material.dart';
import '../../../domain/usecases/play_audio_usecase.dart';
import '../../../domain/usecases/start_recording_usecase.dart';
import '../../../domain/models/conversation_file.dart';
import '../../widgets/audio_button.dart';
import '../../widgets/mic_button.dart';

class ConversationScreen extends StatefulWidget {
  final ConversationFile conversation;
  final PlayAudioUseCase playAudioUseCase;
  final StartRecordingUseCase startRecordingUseCase;

  const ConversationScreen({
    required this.conversation,
    required this.playAudioUseCase,
    required this.startRecordingUseCase,
    Key? key,
  }) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _recognizedText = "";
  bool _isRecording = false;

  void _onPlayAudio() {
    widget.playAudioUseCase.execute(widget.conversation.filePath);
  }

  void _onStartRecording() async {
    setState(() {
      _isRecording = true;  // Bật trạng thái ghi âm
      _recognizedText = "Đang nghe...";  // Hiển thị gợi ý nhận diện
    });

    final result = await widget.startRecordingUseCase.execute();

    setState(() {
      _recognizedText = result;
      _isRecording = false;  // Tắt trạng thái ghi âm
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hội thoại'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildConversationBox(),
            const Spacer(),
            _buildIndicators(),
            const SizedBox(height: 20),
            MicButton(onPressed: _onStartRecording),
            const SizedBox(height: 20),
            Text(
              _recognizedText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/avatar.png'),
            radius: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation.conversationText,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dịch nghĩa',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          AudioButton(onPressed: _onPlayAudio),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index % 2 == 0 ? Colors.green : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget _buildListeningText() {
    return Text(
      _recognizedText.isEmpty ? "Ấn nút micro để bắt đầu" : _recognizedText,
      style: const TextStyle(
        fontSize: 20,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMicButton() {
    return FloatingActionButton(
      onPressed: _onStartRecording,
      backgroundColor: Colors.green,
      child: Icon(
        Icons.mic,
        color: Colors.white,
        size: 28,
      ),
    );
  }

// Hiển thị 3 dấu chấm khi đang ghi âm
  Widget _buildRecordingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIndicator(_isRecording),
        _buildIndicator(_isRecording),
        _buildIndicator(_isRecording),
      ],
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }

}