import 'package:flutter/material.dart';
import 'dart:math' as math;

class CompassPainter extends CustomPainter {
  final double min;
  final double max;
  final double startAngle;
  final double angleRange;

  CompassPainter({
    required this.min,
    required this.max,
    required this.startAngle,
    required this.angleRange,
  });

  // Function to convert degrees to radians
  double radians(double degrees) {
    return degrees * (math.pi / 180);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final outerRadius = radius - 10; // Position just outside the track
    final innerRadius = outerRadius - 8; // Length of the tick

    // Define the intervals to display (16, 24, 32)
    final intervals = [16.0, 24.0, 32.0];

    for (var temp in intervals) {
      // Map the temperature to an angle
      final fraction = (temp - min) / (max - min);
      final angle = radians(startAngle + fraction * angleRange);

      // Calculate the start and end points of the tick
      final startX = center.dx + innerRadius * math.cos(angle);
      final startY = center.dy + innerRadius * math.sin(angle);
      final endX = center.dx + outerRadius * math.cos(angle);
      final endY = center.dy + outerRadius * math.sin(angle);

      // Draw the tick
      final paint = Paint()
        ..color = Colors.grey.shade600
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );

      // Draw the label above the tick
      final textPainter = TextPainter(
        text: TextSpan(
          text: temp.round().toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Position the text above the tick
      final textRadius = outerRadius + 10; // Adjust distance above the tick
      final textX =
          center.dx + textRadius * math.cos(angle) - textPainter.width / 2;
      final textY =
          center.dy + textRadius * math.sin(angle) - textPainter.height / 2;
      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
