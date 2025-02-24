import 'dart:math';
import 'package:flutter/material.dart';

import '../models/word.dart';

class FlashCard extends StatefulWidget {
  final Word word;
  final int index; // Thêm tham số index để hiển thị

  const FlashCard({super.key, required this.word, required this.index});

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
                _buildFrontCard(),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: _buildBackCard(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Stack(
      children: [
        _buildCard(
          child: Center(
            child: Text(
              widget.word.word,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 15,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade100, // Màu xanh lá nhẹ
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '#${widget.index + 1}', // Hiển thị số thứ tự
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),

      ],
    );
  }


  Widget _buildBackCard() {
    return _buildCard(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (widget.word.meaning is List<String>)
                  ? widget.word.meaning.join(", ")
                  : widget.word.meaning.toString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              widget.word.pinyin as String,
              style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            if (widget.word.image != null) ...[
              const SizedBox(height: 15),
              Image.network(
                widget.word.image!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
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
      child: child,
    );
  }
}
