import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

class KanjivocabLearnScreen extends StatefulWidget {
  @override
  _KanjivocabLearnScreenState createState() => _KanjivocabLearnScreenState();
}

class _KanjivocabLearnScreenState extends State<KanjivocabLearnScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;


  final List<Map<String, dynamic>> flashcards = [
    {"word": "你好", "meaning": "Xin chào", "status": true},
    {"word": "谢谢", "meaning": "Cảm ơn", "status": false},
    {"word": "再见", "meaning": "Tạm biệt", "status": false},
  ];

  void updateStatus(int index) {
    setState(() {
      flashcards[index]["status"] = !flashcards[index]["status"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${_currentIndex + 1}/${flashcards.length}', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {},
          ),
        ],
        elevation: 6,
        shadowColor: Colors.black54,
        backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light, // Cho iOS: (biểu tượng sáng)
            statusBarIconBrightness: Brightness.dark, // Cho Android: (biểu tượng tối)
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: flashcards.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return FlashCard(
                  key: PageStorageKey(index),
                  frontText: flashcards[index]["word"]!,
                  backText: flashcards[index]["meaning"]!,
                  isLearned: flashcards[index]["status"],
                  onLearned: () => updateStatus(index),
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
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                      : null,
                  icon: Icon(
                    Icons.arrow_back,
                    color: _currentIndex > 0 ? Colors.black : Colors.grey, // Đổi màu icon
                  ),
                  label: Text(
                    "Trước",
                    style: TextStyle(
                      color: _currentIndex > 0 ? Colors.black : Colors.grey, // Đổi màu text
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Xử lý mở màn hình chi tiết
                  },
                  icon: Icon(Icons.info_outline, color: Colors.black),
                  label: Text(
                    "Chi tiết",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    backgroundColor: Colors.transparent, // 🔥 Nền trong suốt
                    shadowColor: Colors.transparent, // 🔥 Loại bỏ hiệu ứng bóng
                  ),
                ),
                TextButton.icon(
                  onPressed: _currentIndex < flashcards.length - 1
                      ? () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                      : null,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: _currentIndex < flashcards.length - 1 ? Colors.black : Colors.grey, // Đổi màu icon
                  ),
                  label: Text(
                    "Sau",
                    style: TextStyle(
                      color: _currentIndex < flashcards.length - 1 ? Colors.black : Colors.grey, // Đổi màu text
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

class FlashCard extends StatefulWidget {
  final String frontText;
  final String backText;
  final bool isLearned;
  final VoidCallback onLearned;

  FlashCard({Key? key, required this.frontText, required this.backText, required this.isLearned, required this.onLearned}) : super(key: key);

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
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
            transform: Matrix4.rotationY(_animation.value)..setEntry(3, 2, 0.001),
            child: IndexedStack(
              alignment: Alignment.center,
              index: _animation.value > pi / 2 ? 1 : 0,
              children: [
                _buildCard(widget.frontText, isFront: true),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: _buildCard(widget.backText, isFront: false),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(String text, {bool isFront = false}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 35, 25, 20),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isFront) ...[
            const SizedBox(height: 20),
            const Row(
              children: [
                SizedBox(width: 5,),
                Icon(Icons.volume_up_outlined, size: 26, color: Colors.grey),
                Expanded(child: SizedBox()),
                Icon(Icons.star_border, size: 26, color: Colors.grey),
                SizedBox(width: 5,),
              ],
            ),
          ],
          Expanded(
            child: Center(
              child: Text(
                text,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (isFront) ...[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.onLearned,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isLearned ? Colors.green : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                side: BorderSide(color: Colors.grey, width: 1), // Viền màu xanh lá
              ),
              child: Text(
                "Đã thuộc",
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isLearned ? Colors.white : Colors.green, // Màu chữ thay đổi
                ),
              ),
            ),
          ],
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
