import 'package:flutter/material.dart';
import '/models/pronunciation_assessment_result.dart';
import '/services/pronunciation_assessment_service.dart';

class PronunciationAssessmentWidget extends StatefulWidget {
  final String textToPronounce;

  const PronunciationAssessmentWidget({super.key, required this.textToPronounce});

  @override
  _PronunciationAssessmentWidgetState createState() =>
      _PronunciationAssessmentWidgetState();
}

class _PronunciationAssessmentWidgetState
    extends State<PronunciationAssessmentWidget> {
  final PronunciationAssessmentService _assessmentService = PronunciationAssessmentService();
  bool _assessmentFetched = false;

  @override
  void dispose() {
    _assessmentService.dispose();
    super.dispose();
  }

  void _handleRecording(RecordingState recordingState) async {
    if (recordingState == RecordingState.idle) {
      await _assessmentService.startRecording();
      setState(() {
        _assessmentFetched = false;
      });
    } else if (recordingState == RecordingState.recording) {
      await _assessmentService.stopRecording();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phát âm: ${widget.textToPronounce}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // 🎙 Nút bấm ghi âm
        StreamBuilder<RecordingState>(
          stream: _assessmentService.recordingStateStream,
          builder: (context, snapshot) {
            final recordingState = snapshot.data ?? RecordingState.idle;

            if (recordingState == RecordingState.stopped && !_assessmentFetched) {
              _assessmentFetched = true;
              _assessmentService.fetchAssessment(text: widget.textToPronounce);
            }

            return ElevatedButton(
              onPressed: () => _handleRecording(recordingState),
              child: Text(
                recordingState == RecordingState.recording
                    ? 'Dừng Ghi âm'
                    : 'Bắt đầu Ghi âm',
              ),
            );
          },
        ),

        const SizedBox(height: 10),

        // 📊 Hiển thị kết quả đánh giá
        StreamBuilder<PronunciationAssessmentResult?>(
          stream: _assessmentService.assessmentResultStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Lỗi: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              final result = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Điểm tổng: ${result.nBest.isNotEmpty ? result.nBest[0].pronunciationAssessment.pronScore : "N/A"}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Text("Chi tiết: ${result.toJson()}"),
                ],
              );
            }

            return const Text('Chưa có kết quả');
          },
        ),
      ],
    );
  }
}
