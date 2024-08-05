import 'dart:math';

import 'package:flutter/material.dart';

class MovieReservationScreen extends StatefulWidget {
  const MovieReservationScreen({super.key});

  @override
  _MovieReservationScreenState createState() => _MovieReservationScreenState();
}

class _MovieReservationScreenState extends State<MovieReservationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Movie Reservation Screen'),
      // body: Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16),
      //     child: CustomPaint(
      //       painter: MyPainter(),
      //       child: const SizedBox(width: 128, height: 64),
      //     ),
      //   ),
      // ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final redCircle = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    final arcRect = Rect.fromCircle(
        center: size.bottomCenter(Offset.zero), radius: size.shortestSide);
    canvas.drawArc(arcRect, 0, -pi, false, redCircle);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => false;
}
