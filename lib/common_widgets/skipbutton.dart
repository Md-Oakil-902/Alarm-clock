import 'package:flutter/material.dart';

import '../helper/responsive.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double topPadding;
  final double rightPadding;

  const SkipButton({
    super.key,
    required this.onPressed,
    this.text = "Skip",
    this.topPadding = 5,
    this.rightPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Positioned(
      top: Responsive.hp(topPadding),
      right: Responsive.wp(rightPadding),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.wp(4),
            vertical: Responsive.hp(1),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}