import 'package:flutter/material.dart';

class Responsive {
  static late double screenWidth;
  static late double screenHeight;

  // base design from figma
  static const double baseWidth = 360;
  static const double baseHeight = 800;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  static double width(double width) {
    return width * (screenWidth / baseWidth);
  }

  static double height(double height) {
    return height * (screenHeight / baseHeight);
  }

  static double text(double size, BuildContext context) {
    double scale = screenWidth / baseWidth;
    double result = size * scale;

    if (result < size * 0.85) result = size * 0.85;
    if (result > size * 1.3) result = size * 1.3;

    return result;
  }

  static double hp(double percent) {
    return screenHeight * (percent / 100);
  }

  static double wp(double percent) {
    return screenWidth * (percent / 100);
  }
}
