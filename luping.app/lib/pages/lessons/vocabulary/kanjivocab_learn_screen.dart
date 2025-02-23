import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:luping/models/word.dart';
import 'package:luping/widgets/flashcard.dart';

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

  void showDetailInfo(BuildContext context, Word word) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  word.word,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Nghĩa: ${(word.meaning is List<String>) ? word.meaning.join(", ") : word.meaning}",
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 10),
              Text(
                "Pinyin: ${word.pinyin}",
                style: const TextStyle(
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey),
              ),
              if (word.image != null) ...[
                const SizedBox(height: 15),
                Center(
                  child: Image.network(
                    word.image!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text("Đóng", style: TextStyle(color: Colors.blue)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${_currentIndex + 1}/${widget.vocabularies.length}',
            style: const TextStyle(fontSize: 18)),
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
                  index: index,
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
                    showDetailInfo(context, widget.vocabularies[_currentIndex]);
                  },
                  icon: const Icon(Icons.info_outline, color: Colors.black),
                  label: const Text(
                    "Chi tiết",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
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
                    color: _currentIndex < widget.vocabularies.length - 1
                        ? Colors.black
                        : Colors.grey,
                  ),
                  label: Text(
                    "Sau",
                    style: TextStyle(
                      color: _currentIndex < widget.vocabularies.length - 1
                          ? Colors.black
                          : Colors.grey,
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
