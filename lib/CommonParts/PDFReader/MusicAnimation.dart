import 'package:flutter/material.dart';
import 'dart:math';

class BarAnimationPainter extends CustomPainter {
  final Animation<double> barHeight;

  // List of colors for the bars
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.pink,
    Colors.lime,
    Colors.teal
  ];

  BarAnimationPainter(this.barHeight) : super(repaint: barHeight);

  @override
  void paint(Canvas canvas, Size size) {
    const int barCount = 15; // Number of bars
    const double spacing = 10.0; // Spacing between bars
    final double barWidth = (size.width - (barCount - 1) * spacing) / barCount; // Adjust bar width to fit
    final double midHeight = size.height / 2; // Center of the canvas for bouncing
    final double startX = (size.width - (barCount * barWidth + (barCount - 1) * spacing)) / 2; // Start X for centering

    for (int i = 0; i < barCount; i++) {
      double left = startX + i * (barWidth + spacing);
      double right = left + barWidth;

      // Bouncing effect for the bars
      double bounceValue = sin((i + barHeight.value) * pi / 2) * 30; // Adjust amplitude
      double top = midHeight - bounceValue;
      double bottom = midHeight + bounceValue;

      final paint = Paint()..color = colors[i % colors.length]; // Color loop

      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
