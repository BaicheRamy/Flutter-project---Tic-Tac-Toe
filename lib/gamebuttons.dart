import 'package:flutter/material.dart';

class GameButton {
  late int id;
  late Color clr;
  late bool enabled;
  late String str;
  late Color stringColor;
  GameButton(id) {
    this.id = id;
    this.clr = Color(0xFF211354);
    this.stringColor = Color(0xFF600CFF);
    this.enabled = true;
    this.str = '';
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    canvas.drawLine(
      Offset(size.width * 1 / 6, size.height * 1 / 2),
      Offset(size.width * 5 / 6, size.height * 1 / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
