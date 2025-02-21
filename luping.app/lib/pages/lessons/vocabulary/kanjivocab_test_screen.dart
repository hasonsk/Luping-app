import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'test_summary_screen.dart';
import 'question_form.dart';
import 'dart:async';

class KanjivocabTestScreen extends StatefulWidget {
  const KanjivocabTestScreen({super.key});

  @override
  _KanjivocabTestScreenState createState() => _KanjivocabTestScreenState();
}

class _KanjivocabTestScreenState extends State<KanjivocabTestScreen> {
  final List<Map<String, String>> flashcards = [
    {
      "word": "你好",
      "meaning": "Xin chào",
      "pinyin": "nǐ hǎo",
      "imgURL": "https://assets.hanzii.net/img_word/7eca689f0d3389d9dea66ae112e5cfd7_h.jpg"
    },
    {
      "word": "谢谢",
      "meaning": "Cảm ơn",
      "pinyin": "xièxie",
      "imgURL": "https://assets.hanzii.net/img_word/a34490b593cdc390c77104721ba7eb39_h.jpg"
    },
    {
      "word": "再见",
      "meaning": "Tạm biệt",
      "pinyin": "zàijiàn",
      "imgURL": "https://assets.hanzii.net/img_word/8e5c0a1e46703251c02613c1048177f1_h.jpg"
    },
    {
      "word": "我们",
      "meaning": "Chúng tôi",
      "pinyin": "wǒmen",
      "imgURL": "https://assets.hanzii.net/img_word/ab4a85fc2ec4cf830e0f84aaacefcb1c_h.jpg"
    },
  ];

  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  final List<bool> _results = [];
  bool _showImages = true;
  bool _isLoading = true; // Trạng thái load ảnh

  @override
  void initState() {
    super.initState();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    for (var card in flashcards) {
      if (card["imgURL"] != null && card["imgURL"]!.isNotEmpty) {
        try {
          final img = Image.network(card["imgURL"]!);
          final Completer<void> completer = Completer();
          img.image.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener(
                  (info, _) => completer.complete(),
              onError: (error, stackTrace) {
                print("Lỗi tải ảnh: ${card["imgURL"]} - $error");
                completer.complete(); // Vẫn tiếp tục load ảnh khác
              },
            ),
          );
          await completer.future;
        } catch (e) {
          print("Lỗi tải ảnh: ${card["imgURL"]} - $e");
        }
      }
    }
    setState(() => _isLoading = false);
  }

  void _nextQuestion(bool isCorrect) {
    if (isCorrect) _correctAnswers++;
    _results.add(isCorrect);

    if (_currentQuestionIndex < flashcards.length - 1) {
      setState(() => _currentQuestionIndex++);
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TestSummaryScreen(
            totalQuestions: flashcards.length,
            correctAnswers: _correctAnswers,
            results: _results,
          ),
        ),
      );
    }
  }

  Future<bool> _showExitConfirmation() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có muốn thoát khỏi bài kiểm tra không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Không")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Có")),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitConfirmation,
      child: Scaffold(
        appBar: AppBar(
          title: LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / flashcards.length,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            color: Colors.green,
          ),
          centerTitle: true,
          elevation: 6,
          shadowColor: Colors.black54,
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          actions: [
            IconButton(
              icon: Icon(_showImages ? Icons.perm_media_rounded : Icons.visibility_off),
              onPressed: () => setState(() => _showImages = !_showImages),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo trục dọc
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10), // Thêm khoảng cách giữa các phần tử
              Text('Đang tải...')
            ],
          ),
        )
            : PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: flashcards.length,
          itemBuilder: (context, index) {
            return QuestionForm(
              question: flashcards[index],
              allOptions: flashcards,
              onNextQuestion: _nextQuestion,
              showImages: _showImages,
            );
          },
        ),
      ),
    );
  }
}
