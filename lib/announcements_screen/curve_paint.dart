import 'package:flutter/material.dart';

import '../utils.dart';
import 'announcements_screen.dart';

// DO NOT MODIFY THE VALUES
class DashedPathPainter extends CustomPainter {
  const DashedPathPainter({
    required this.context,
    required this.isCompleted,
  });
  final BuildContext context;
  final List<bool> isCompleted;
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(relx(context, 0.14), rely(context, 0.095));
    path.quadraticBezierTo(
      relx(context, 0.09),
      rely(context, 0.17),
      relx(context, 0.2),
      rely(context, 0.19),
    );

    var path2 = Path();
    path2.moveTo(relx(context, 0.25), rely(context, 0.215));
    path2.quadraticBezierTo(
      relx(context, 0.5),
      rely(context, 0.3),
      relx(context, 0.4),
      rely(context, 0.37),
    );

    var path3 = Path();
    path3.moveTo(relx(context, 0.4), rely(context, 0.44));
    path3.quadraticBezierTo(
      relx(context, 0.3),
      rely(context, 0.55),
      relx(context, 0.59),
      rely(context, 0.57),
    );

    var path4 = Path();
    path4.moveTo(relx(context, 0.84), rely(context, 0.365));
    path4.quadraticBezierTo(
      relx(context, 0.9),
      rely(context, 0.55),
      relx(context, 0.7),
      rely(context, 0.57),
    );

    var path5 = Path();
    path5.moveTo(relx(context, 0.85), rely(context, 0.215));
    path5.quadraticBezierTo(
      relx(context, 0.8),
      rely(context, 0.25),
      relx(context, 0.825),
      rely(context, 0.3),
    );

    var path6 = Path();
    path6.moveTo(relx(context, 0.8), rely(context, 0.11));
    path6.quadraticBezierTo(
      relx(context, 0.9),
      rely(context, 0.13),
      relx(context, 0.88),
      rely(context, 0.145),
    );

    var path7 = Path();
    path7.moveTo(relx(context, 0.55), rely(context, 0.06));
    path7.quadraticBezierTo(
      relx(context, 0.55),
      rely(context, 0.1),
      relx(context, 0.69),
      rely(context, 0.1),
    );

    drawDashedPath(canvas, path, isCompleted[0]);
    drawDashedPath(canvas, path2, isCompleted[1]);
    drawDashedPath(canvas, path3, isCompleted[2]);
    drawDashedPath(canvas, path4, isCompleted[3]);
    drawDashedPath(canvas, path5, isCompleted[4]);
    drawDashedPath(canvas, path6, isCompleted[5]);
    drawDashedPath(canvas, path7, isCompleted[6]);
  }

  void drawDashedPath(Canvas canvas, Path path, bool isCompleted) {
    Color color = isCompleted ? primaryColor : Colors.grey;
    var paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    var dashWidth = 5.0;
    var dashSpace = 2.5;
    double distance = 0.0;

    for (var pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        var length = (distance + dashWidth).clamp(0.0, pathMetric.length);
        var extractPath = pathMetric.extractPath(distance, length);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0; // reset distance for next pathMetric
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
