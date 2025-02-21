import 'dart:async';
import 'package:flutter/material.dart';

class SearchContainer extends StatefulWidget {
  const SearchContainer({super.key});

  @override
  _SearchContainerState createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  bool showCursor = true;
  Timer? cursorTimer;

  @override
  void initState() {
    super.initState();
    _startCursorTimer();
  }

  void _startCursorTimer() {
    cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        showCursor = !showCursor;
      });
    });
  }

  @override
  void dispose() {
    cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20),
                const SizedBox(width: 5),
                Container(
                  width: 2,
                  height: 20,
                  color: showCursor ? Colors.green : Colors.transparent,
                  margin: const EdgeInsets.only(left: 2.0),
                ),
                const SizedBox(width: 3),
                const Text(
                  'Tìm kiếm ...',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(color: Colors.green),
            child: const Center(
              child: Icon(Icons.search, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
