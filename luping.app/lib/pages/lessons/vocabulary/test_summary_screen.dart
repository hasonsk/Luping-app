import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestSummaryScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<bool> results;

  const TestSummaryScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    double score = (correctAnswers / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thống kê kết quả',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  CircularProgressIndicator(
                    value: score / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        score >= 70 ? Colors.green : Colors.red),
                    strokeWidth: 8,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Điểm số: ${score.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ListView.builder(
                    shrinkWrap: true, // Giúp ListView chỉ chiếm chỗ cần thiết
                    physics: const NeverScrollableScrollPhysics(), // Ngăn ListView cuộn riêng
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          results[index] ? Icons.check_circle : Icons.cancel,
                          color: results[index] ? Colors.green : Colors.red,
                        ),
                        title: Text('Câu ${index + 1}: ${results[index] ? "Đúng" : "Sai"}'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity, // Chiếm toàn bộ chiều rộng
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Trở về trang chủ', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
