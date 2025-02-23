import 'package:flutter/material.dart';
import 'dart:math';

class QuestionForm extends StatefulWidget {
  final Map<String, String> question;
  final List<Map<String, String>> allOptions;
  final Function(bool) onNextQuestion;
  final bool showImages;

  const QuestionForm({
    super.key,
    required this.question,
    required this.allOptions,
    required this.onNextQuestion,
    required this.showImages,
  });

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
    // Lọc ra các từ không phải là đáp án đúng
    List<Map<String, String>> incorrectOptions = widget.allOptions
        .where((opt) => opt["word"] != widget.question["word"])
        .toList();

    // Trộn danh sách lựa chọn sai
    incorrectOptions.shuffle();

    // Chọn ra 3 lựa chọn sai
    List<Map<String, String>> selectedOptions = incorrectOptions.take(3).toList();

    // Thêm đáp án đúng vào danh sách
    selectedOptions.add(widget.question);

    // Trộn lại danh sách để vị trí của đáp án đúng không cố định
    selectedOptions.shuffle();

    // Gán lại cho _options
    _options = selectedOptions;
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 0.4,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green : Colors.red,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isCorrect ? 'Bạn đang làm rất tốt!' : 'Không chính xác!',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Đáp án:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.question["word"]!,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.question["meaning"]!,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 24),
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
                    child: const Text('Tiếp tục'),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: SizedBox()),
          Text(
            'Từ nào sau đây có nghĩa là: "${widget.question["meaning"]!}"',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  width: _selectedAnswer == _options[index]["word"] ? 2.5 : 1,
                ),
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: widget.showImages
                        ? Image.network(
                            _options[index]["image"]!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                          )
                        : const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      _options[index]["word"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedAnswer == null ? null : _checkAnswer,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text(
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
