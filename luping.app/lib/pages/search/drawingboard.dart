import 'package:flutter/material.dart';

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  final List<Offset?> _points = [];
  String _recognizedResult = "";
  late Handwriting _handwriting;

  @override
  void initState() {
    super.initState();
    _handwriting = Handwriting(width: 300, height: 200);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "Vẽ ký tự tiếng Trung ở đây",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _points.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              _points.add(null);
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: DrawingPainter(_points),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _recognizeHandwriting();
          },
          child: const Text("Nhận diện"),
        ),
        const SizedBox(height: 20),
        Text(
          "Kết quả nhận diện: $_recognizedResult",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _recognizeHandwriting() {
    List<List<List<int>>> rawTrace = _convertPointsToTrace(_points);
    print("Trace: $rawTrace");

    List<List<int>> trace = [];
    for (var stroke in rawTrace) {
      if (stroke.length == 2) {
        trace.add(stroke[0]);
        trace.add(stroke[1]);
      }
    }

    var options = {
      'language': 'zh_TW',
      'numOfReturn': 5,
      'numOfWords': 2,
    };

    _handwriting.recognize(
      trace,
      options,
          (results, error) {
        setState(() {
          _recognizedResult = error != null ? "Error: ${error.toString()}" : results?.toString() ?? "No result";
        });
      },
    );
  }

  List<List<List<int>>> _convertPointsToTrace(List<Offset?> points) {
    List<List<List<int>>> trace = [];
    List<int> xCoords = [];
    List<int> yCoords = [];

    for (var point in points) {
      if (point != null) {
        xCoords.add(point.dx.toInt());
        yCoords.add(point.dy.toInt());
      } else if (xCoords.isNotEmpty && yCoords.isNotEmpty) {
        trace.add([xCoords, yCoords]);
        xCoords = [];
        yCoords = [];
      }
    }

    if (xCoords.isNotEmpty && yCoords.isNotEmpty) {
      trace.add([xCoords, yCoords]);
    }

    return trace;
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class Handwriting {
  final int width;
  final int height;

  Handwriting({required this.width, required this.height});

  void recognize(List<List<int>> trace, Map<String, dynamic> options, Function(dynamic, dynamic) callback) {
    // Giả lập quá trình nhận diện chữ viết tay
    Future.delayed(const Duration(seconds: 1), () {
      callback(["字", "汉"], null); // Kết quả giả định
    });
  }
}
