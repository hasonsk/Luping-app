import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:hanjii/models/word.dart';
import 'package:hanjii/widgets/flashcard.dart';

class KanjivocabLearnScreen extends StatefulWidget {
  final List<Word> vocabularies;
  const KanjivocabLearnScreen({super.key, required this.vocabularies});

  @override
  _KanjivocabLearnScreenState createState() => _KanjivocabLearnScreenState();
}

class _KanjivocabLearnScreenState extends State<KanjivocabLearnScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${_currentIndex + 1}/${widget.vocabularies.length}', style: const TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 6,
        shadowColor: Colors.black54,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.vocabularies.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return FlashCard(
                  key: PageStorageKey(index),
                  word: widget.vocabularies[index],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _currentIndex > 0
                      ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                      : null,
                  icon: Icon(
                    Icons.arrow_back,
                    color: _currentIndex > 0 ? Colors.black : Colors.grey,
                  ),
                  label: Text(
                    "Trước",
                    style: TextStyle(
                      color: _currentIndex > 0 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Xử lý mở màn hình chi tiết
                  },
                  icon: const Icon(Icons.info_outline, color: Colors.black),
                  label: const Text(
                    "Chi tiết",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
                TextButton.icon(
                  onPressed: _currentIndex < widget.vocabularies.length - 1
                      ? () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                      : null,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: _currentIndex < widget.vocabularies.length - 1 ? Colors.black : Colors.grey,
                  ),
                  label: Text(
                    "Sau",
                    style: TextStyle(
                      color: _currentIndex < widget.vocabularies.length - 1 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
