import 'package:flutter/material.dart';
import '/models/pronunciation_assessment_result.dart';
import '/services/pronunciation_assessment_service.dart';

class PronunciationAssessmentWidget extends StatefulWidget {
  final String textToPronounce;
  final PronunciationAssessmentService assessmentService;

  const PronunciationAssessmentWidget({
    super.key,
    required this.textToPronounce,
    required this.assessmentService,
  });

  @override
  _PronunciationAssessmentWidgetState createState() =>
      _PronunciationAssessmentWidgetState();
}

class _PronunciationAssessmentWidgetState extends State<PronunciationAssessmentWidget> {
  final PageController _pageController = PageController();
  bool _isProcessing = false;
  bool _hasResult = false;
  RecordingState _recordingState = RecordingState.idle;
  PronunciationAssessmentResult? _latestResult;
  late PronunciationAssessmentService _assessmentService;
  late Future<void> _recordingTimer; // Thêm biến này

  @override
  void initState() {
    super.initState();
    _assessmentService = widget.assessmentService;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Xử lý ghi âm
  void _handleRecording() async {
    if (_recordingState == RecordingState.idle || _recordingState == RecordingState.stopped) {
      await _assessmentService.startRecording();
      setState(() {
        _recordingState = RecordingState.recording;
        _hasResult = false;
      });

      // Đặt timer 10 giây tự động dừng nếu người dùng không nhấn dừng
      _recordingTimer = Future.delayed(const Duration(seconds: 10), () {
        if (_recordingState == RecordingState.recording) {
          _stopRecording();
        }
      });
    } else if (_recordingState == RecordingState.recording) {
      _stopRecording();
    }
  }

  void _stopRecording() async {
    await _assessmentService.stopRecording();
    setState(() {
      _recordingState = RecordingState.stopped;
    });

    _assessmentService.resetAssessment();
    _fetchAssessment();

    // Hủy timer khi dừng ghi âm
    _recordingTimer = Future.value();
  }

  /// Lấy kết quả đánh giá
  void _fetchAssessment() async {
    final result = await _assessmentService.fetchAssessment(text: widget.textToPronounce);

    if (mounted) {
      setState(() {
        _hasResult = true;
        _latestResult = result;
      });

      // Nếu điểm >= 80, tự động chuyển trang chúc mừng
      final isHighScore = result?.nBest.isNotEmpty == true &&
          result!.nBest[0].pronunciationAssessment.pronScore >= 80;

      if (isHighScore) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildRecordingPage(),
            _buildSuccessPage(),
          ],
        ),
      ),
    );
  }

  /// Trang 1: Ghi âm và hiển thị kết quả
  Widget _buildRecordingPage() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 30),
        const Text(
          'Hãy đọc to:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          widget.textToPronounce,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: _handleRecording,
          child: Text(
            _recordingState == RecordingState.recording
                ? 'Dừng Ghi âm'
                : (_hasResult ? 'Ghi âm lại' : 'Bắt đầu Ghi âm'),
          ),
        ),

        const SizedBox(height: 20),

        Expanded(
          child: Center(
            child: _recordingState == RecordingState.recording
                ? const CircularProgressIndicator()
                : (_hasResult
                ? (_latestResult != null && _latestResult!.nBest.isNotEmpty)
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                Text(
                  _latestResult!.nBest[0].pronunciationAssessment.pronScore >= 80
                      ? 'Điểm tổng: ${_latestResult!.nBest[0].pronunciationAssessment.pronScore}'
                      : 'Bạn gần làm được rồi, thử lại lần nữa nào!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )
                : const Text("Không có kết quả đánh giá")
                : const SizedBox()),
          ),
        ),
      ],
    );
  }

  /// Trang 2: Chúc mừng và chuyển câu
  Widget _buildSuccessPage() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "🎉 Chúc mừng! Bạn đã phát âm rất tốt! 🎉",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (mounted) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  Navigator.of(context).pop(true);
                }
              });
            }
          },
          child: const Text('Câu tiếp theo'),
        ),
      ],
    );
  }
}
