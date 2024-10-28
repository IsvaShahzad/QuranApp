import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class StarPainter extends CustomPainter {
  final String number;

  StarPainter(this.number);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal // Set the color to teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Define points for the octagon
    final path = Path();
    final radius = size.width / 1.5; // Use half the width for the radius
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 8; i++) {
      double angle = (i * 2 * pi) / 8; // 2π/8 for 8 points
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y); // Move to the first point
      } else {
        path.lineTo(x, y); // Draw line to the next point
      }
    }

    path.close(); // Close the path

    canvas.drawPath(path, paint);

    // Draw the number inside the octagon
    final textPainter = TextPainter(
      text: TextSpan(
        text: number,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
