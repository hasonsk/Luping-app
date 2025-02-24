import 'package:flutter/material.dart';

class TriangleIndicator extends Decoration {
  final Color color;

  const TriangleIndicator({required this.color});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TrianglePainter(color: color);
  }
}

class _TrianglePainter extends BoxPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()..color = color;

    final Rect rect = offset & configuration.size!;

    // Chiều cao và chiều rộng cố định cho tam giác
    const double triangleHeight = 8.0;
    const double triangleWidth = 20.0;

    // Tính toán vị trí tam giác sao cho nó nằm ở giữa theo chiều ngang
    final double triangleStartX = rect.left + (rect.width - triangleWidth) / 2;
    final Path path = Path()
      ..moveTo(triangleStartX, rect.bottom) // Bắt đầu từ bên trái của tam giác
      ..lineTo(triangleStartX + triangleWidth / 2,
          rect.bottom - triangleHeight) // Đỉnh tam giác ở giữa
      ..lineTo(triangleStartX + triangleWidth,
          rect.bottom) // Kết thúc bên phải của tam giác
      ..close(); // Đóng tam giác

    canvas.drawPath(path, paint);
  }
}
