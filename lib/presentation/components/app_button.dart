import 'dart:io';
import 'package:flutter/material.dart';

class AppTouchable extends StatelessWidget {
  final dynamic data;
  final Widget child;
  final dynamic onPress;

  const AppTouchable({required this.child, this.data, this.onPress, super.key});

  void onPressCallBack() {
    if (data != null) {
      onPress(data);
    } else {
      onPress();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return InkWell(
        onTap: onPressCallBack,
        child: child,
      );
    } else {
      return GestureDetector(
        onTap: onPressCallBack,
        child: child,
      );
    }
  }
}