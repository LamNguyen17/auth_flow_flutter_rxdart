import 'package:flutter/material.dart';

class BoxWapper extends StatelessWidget {
  final Color? borderColor;
  final Color? color;
  final String? title;
  final double? borderWidth;
  final double? borderRadius;

  const BoxWapper(
      {super.key,
      this.borderColor,
      this.color,
      this.title,
      this.borderWidth,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.loose, children: <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 1.0,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
        ),
        child: Text(title ?? ''),
      )
    ]);
  }
}
