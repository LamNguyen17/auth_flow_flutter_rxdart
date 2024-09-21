import 'dart:ui';
import 'package:flutter/material.dart';

class ProjectorWidget extends StatelessWidget {
  const ProjectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 16.0;
    return Stack(
      children: [
        CustomPaint(
          painter: CurvePainter(),
          child: Container(
              width: screenWidth, height: 250, color: Colors.transparent),
        ),
        Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: SizedBox(
              width: screenWidth,
              height: 250,
              child: ClipPath(
                clipper: CurveClipper(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.orangeAccent,
                            Colors.orangeAccent.withAlpha(1),
                            Colors.black,
                          ],
                          // begin: FractionalOffset(0.0, 1.0),
                          // end: FractionalOffset(0.0, 0.0),
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    // color: Colors.orangeAccent.withOpacity(0.1),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Start at the left center of the canvas
    path.moveTo(0, size.height / 2);

    // Draw a quadratic Bezier curve
    path.quadraticBezierTo(
      // size.width / 2, size.height, // control point
      // size.width, size.height / 2, // end point
      size.width / 2, 0, // control point at the top center
      size.width, size.height / 2, // end point at the middle right
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      // size.width / 2, size.height, // control point
      // size.width, size.height / 2, // end point
      size.width / 2, 0, // control point at the top center
      size.width, size.height / 2, // end point at the middle right
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
