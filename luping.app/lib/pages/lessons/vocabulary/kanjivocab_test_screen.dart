import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luping/models/word.dart';
import 'test_summary_screen.dart';
import 'question_form.dart';
import 'dart:async';

class KanjivocabTestScreen extends StatefulWidget {
  final List<Word> vocabularies;
  const KanjivocabTestScreen({super.key, required this.vocabularies});

  @override
  _KanjivocabTestScreenState createState() => _KanjivocabTestScreenState();
}

class _KanjivocabTestScreenState extends State<KanjivocabTestScreen> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  final List<bool> _results = [];
  bool _showImages = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    for (var card in widget.vocabularies) {
      if (card.image != null && card.image!.isNotEmpty) {
        try {
          final img = Image.network(card.image!);
          final Completer<void> completer = Completer();
          img.image.resolve(const ImageConfiguration()).addListener(
                ImageStreamListener(
                  (info, _) => completer.complete(),
                  onError: (error, stackTrace) {
                    print("Error loading image: ${card.image} - $error");
                    completer.complete();
                  },
                ),
              );
          await completer.future;
        } catch (e) {
          print("Error loading image: ${card.image} - $e");
        }
      }
    }
    setState(() => _isLoading = false);
  }

  void _nextQuestion(bool isCorrect) {
    if (isCorrect) _correctAnswers++;
    _results.add(isCorrect);

    if (_currentQuestionIndex < widget.vocabularies.length - 1) {
      setState(() => _currentQuestionIndex++);
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TestSummaryScreen(
            totalQuestions: widget.vocabularies.length,
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
            title: const Text("Confirm"),
            content: const Text("Do you want to exit the test?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("No")),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Yes")),
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
            value: (_currentQuestionIndex + 1) / widget.vocabularies.length,
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
              icon: Icon(_showImages
                  ? Icons.perm_media_rounded
                  : Icons.visibility_off),
              onPressed: () => setState(() => _showImages = !_showImages),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading...')
                  ],
                ),
              )
            : PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.vocabularies.length,
                itemBuilder: (context, index) {
                  return QuestionForm(
                    question: widget.vocabularies[index].toMap(),
                    allOptions: widget.vocabularies
                        .map((word) => word.toMap())
                        .toList(),
                    onNextQuestion: _nextQuestion,
                    showImages: _showImages,
                  );
                },
              ),
      ),
    );
  }
}
