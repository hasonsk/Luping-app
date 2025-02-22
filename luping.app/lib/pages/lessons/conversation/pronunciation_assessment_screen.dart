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
  final PronunciationAssessmentService _assessmentService =
  PronunciationAssessmentService();
  bool _isRecording = false;
  bool _isProcessing = false;
  PronunciationAssessmentResult? _assessmentResult;

  @override
  void dispose() {
    _assessmentService.dispose();
    super.dispose();
  }

  Future<void> _handleRecording() async {
    if (_isRecording) {
      // Dừng ghi âm
      await _assessmentService.stopRecording();
      setState(() {
        _isRecording = false;
        _isProcessing = true; // Loading khi xử lý đánh giá
      });
      await _fetchAssessment();
    } else {
      // Xóa file âm thanh cũ và bắt đầu ghi âm mới
      await _assessmentService.startRecording();
      setState(() {
        _isRecording = true;
        _assessmentResult = null; // Xóa kết quả cũ khi ghi âm lại
      });
    }
  }

  Future<void> _fetchAssessment() async {
    final result =
    await _assessmentService.fetchAssessment(text: widget.textToPronounce);
    setState(() {
      _assessmentResult = result;
      _isProcessing = false; // Dừng loading khi có kết quả
    });
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

        // 🎙 Nút ghi âm
        if (_isProcessing)
          const CircularProgressIndicator() // Loading khi gửi dữ liệu
        else
          ElevatedButton(
            onPressed: _handleRecording,
            child: Text(_isRecording ? '⏹ Dừng Ghi âm' : '🎙 Bắt đầu Ghi âm'),
          ),

        const SizedBox(height: 10),

        // 📊 Hiển thị kết quả đánh giá
        if (_assessmentResult != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Điểm tổng: ${_assessmentResult!.nBest.isNotEmpty ? _assessmentResult!.nBest[0].pronunciationAssessment.pronScore : "N/A"}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _handleRecording,
                child: const Text('🔄 Ghi âm lại'),
              ),
            ],
          ),
      ],
    );
  }
}
