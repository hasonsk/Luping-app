import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:luping/models/flashcard.dart';
import 'package:luping/pages/flashcard/flashcard_list_page.dart';
import 'package:luping/services/flashcard_service.dart';

class FlashcardContentPage extends StatefulWidget {
  final Flashcard flashcard;

  const FlashcardContentPage({super.key, required this.flashcard});
  @override
  _FlashcardContentPageState createState() => _FlashcardContentPageState();
}

class _FlashcardContentPageState extends State<FlashcardContentPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${_currentIndex + 1}/${widget.flashcard.items.length}',
            style: const TextStyle(fontSize: 18)),
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
            icon: const Icon(Icons.save),
            onPressed: () {
              _showSaveDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.flashcard.items.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return FlashCard(
                  key: PageStorageKey(index),
                  index: index + 1, // Số thứ tự bắt đầu từ 1
                  frontText: widget.flashcard.items[index].word,
                  backText: widget.flashcard.items[index].shortmeaning,
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
                TextButton.icon(
                  onPressed: _currentIndex < widget.flashcard.items.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: _currentIndex < widget.flashcard.items.length - 1
                        ? Colors.black
                        : Colors.grey,
                  ),
                  label: Text(
                    "Sau",
                    style: TextStyle(
                      color: _currentIndex < widget.flashcard.items.length - 1
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

  void _showSaveDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lưu Flashcard'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Nhập tên flashcard'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                flashcards.remove(widget.flashcard);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Lưu'),
              onPressed: () {
                setState(() {
                  widget.flashcard.title = nameController.text;
                  flashcards.add(widget.flashcard);
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        FlashcardListPage(flashcards: flashcards),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class FlashCard extends StatefulWidget {
  final int index;
  final String frontText;
  final String backText;

  const FlashCard({
    super.key,
    required this.index,
    required this.frontText,
    required this.backText,
  });

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  void _flipCard() {
    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(_animation.value)
              ..setEntry(3, 2, 0.001),
            child: IndexedStack(
              alignment: Alignment.center,
              index: _animation.value > pi / 2 ? 1 : 0,
              children: [
                _buildCard(widget.frontText, isFront: true, showIndex: true),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: _buildCard(widget.backText,
                      isFront: false, showIndex: false),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(String text,
      {bool isFront = false, required bool showIndex}) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (showIndex) // Chỉ hiển thị số thứ tự nếu là mặt trước
            Positioned(
              top: 8,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white, // Đặt màu nền nếu cần
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.grey,
                      width: 1), // Thêm viền màu đen dày 2px
                ),
                child: Text(
                  "#${widget.index}", // Số thứ tự
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
