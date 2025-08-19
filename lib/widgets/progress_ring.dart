import 'dart:math';
import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final int completed;
  final int total;
  final double size;

  const ProgressRing({
    super.key,
    required this.completed,
    required this.total,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: ProgressRingPainter(
          completed: completed,
          total: total,
          backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          progressColor: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Text(
            total > 0 ? '$completed/$total' : '0/0',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  final int completed;
  final int total;
  final Color backgroundColor;
  final Color progressColor;

  ProgressRingPainter({
    required this.completed,
    required this.total,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    const strokeWidth = 4.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (total > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final sweepAngle = (completed / total) * 2 * pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // Start from top
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return completed != oldDelegate.completed ||
        total != oldDelegate.total ||
        backgroundColor != oldDelegate.backgroundColor ||
        progressColor != oldDelegate.progressColor;
  }
}
