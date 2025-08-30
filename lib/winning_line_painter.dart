import 'package:flutter/material.dart';

class WinningLinePainter extends CustomPainter {
  final List<int> winningLine;
  final Animation<double> animation;
  final String winner;

  WinningLinePainter({
    required this.winningLine,
    required this.animation,
    required this.winner,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (winningLine.isEmpty) return;

    final Paint paint = Paint()
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    final startCell = winningLine.first;
    final endCell = winningLine.last;

    final double cellWidth = size.width / 3;
    final double cellHeight = size.height / 3;

    final Offset startOffset = Offset(
      (startCell % 3) * cellWidth + cellWidth / 2,
      (startCell ~/ 3) * cellHeight + cellHeight / 2,
    );

    final Offset endOffset = Offset(
      (endCell % 3) * cellWidth + cellWidth / 2,
      (endCell ~/ 3) * cellHeight + cellHeight / 2,
    );
    
    final currentEndOffset = Offset.lerp(startOffset, endOffset, animation.value)!;

    paint.shader = LinearGradient(
      colors: winner == 'X' 
          ? [const Color(0xFF33D17A), const Color(0xFF33D17A).withOpacity(0.5)] 
          : [const Color(0xFFF95B5B), const Color(0xFFF95B5B).withOpacity(0.5)],
    ).createShader(Rect.fromPoints(startOffset, endOffset));


    canvas.drawLine(startOffset, currentEndOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
