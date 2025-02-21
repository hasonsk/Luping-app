import 'dart:math';
import 'package:flutter/material.dart';

class FlashCard extends StatefulWidget {
  final String frontText;
  final String backText;
  final bool isLearned;
  final VoidCallback onLearned;

  const FlashCard({
    super.key,
    required this.frontText,
    required this.backText,
    required this.isLearned,
    required this.onLearned,
  });

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
                SizedBox(width: 5),
                Icon(Icons.volume_up_outlined, size: 26, color: Colors.grey),
                Expanded(child: SizedBox()),
                Icon(Icons.star_border, size: 26, color: Colors.grey),
                SizedBox(width: 5),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.onLearned,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isLearned ? Colors.green : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                side: const BorderSide(color: Colors.grey, width: 1),
              ),
              child: Text(
                "Đã thuộc",
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isLearned ? Colors.white : Colors.green,
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
