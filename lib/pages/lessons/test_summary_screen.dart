import 'package:flutter/material.dart';

class TestSummaryScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<bool> results;

  const TestSummaryScreen({
    Key? key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double score = (correctAnswers / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(title: Text('Thống kê kết quả')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Kết quả bài kiểm tra',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Bạn đã trả lời đúng $correctAnswers / $totalQuestions câu',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(score >= 70 ? Colors.green : Colors.red),
              strokeWidth: 8,
            ),
            SizedBox(height: 16),
            Text(
              'Điểm số: ${score.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
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
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Làm lại', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
