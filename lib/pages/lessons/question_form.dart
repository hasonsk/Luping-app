import 'package:flutter/material.dart';
import 'dart:math';

class QuestionForm extends StatefulWidget {
  final Map<String, String> question;
  final List<Map<String, String>> allOptions;
  final Function(bool) onNextQuestion;
  final bool showImages; // Trạng thái hiển thị ảnh

  const QuestionForm({
    Key? key,
    required this.question,
    required this.allOptions,
    required this.onNextQuestion,
    required this.showImages, // Nhận trạng thái từ `KanjivocabTestScreen`
  }) : super(key: key);

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  late List<Map<String, String>> _options;
  String? _selectedAnswer;
  bool _isAnswerChecked = false;

  @override
  void initState() {
    super.initState();
    _generateOptions();
  }

  void _generateOptions() {
    _options = List.from(widget.allOptions)..shuffle();
    if (!_options.any((opt) => opt["word"] == widget.question["word"])) {
      _options[Random().nextInt(_options.length)] = widget.question;
    }
  }

  void _checkAnswer() {
    final isCorrect = _selectedAnswer == widget.question["word"];
    setState(() => _isAnswerChecked = true);
    _showBottomSheet(isCorrect);
  }

  void _showBottomSheet(bool isCorrect) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 0.4,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green : Colors.red,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isCorrect ? 'Bạn đang làm rất tốt!' : 'Không chính xác!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Đáp án:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
                ),
                SizedBox(height: 8),
                Text(
                  widget.question["word"]!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  widget.question["meaning"]!,
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onNextQuestion(isCorrect);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: isCorrect ? Colors.green : Colors.red,
                    ),
                    child: Text('Tiếp tục'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question["meaning"]!,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          Expanded(child: SizedBox()),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _options.length,
            itemBuilder: (context, index) => OutlinedButton(
              onPressed: _isAnswerChecked
                  ? null
                  : () => setState(() => _selectedAnswer = _options[index]["word"]),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: _selectedAnswer == _options[index]["word"] ? Colors.blue : Colors.grey,
                ),
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: widget.showImages
                        ? Image.network(
                      _options[index]["imgURL"]!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    )
                        : Icon(Icons.image_not_supported, size: 40, color: Colors.grey), // Nếu ẩn ảnh, hiển thị icon
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      _options[index]["word"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Expanded(child: SizedBox()),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedAnswer == null ? null : _checkAnswer,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Kiểm tra đáp án',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
