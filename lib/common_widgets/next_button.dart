import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../helper/responsive.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.onPressed, required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Padding(
      padding:  EdgeInsets.only(left: Responsive.hp(3), right: Responsive.hp(3), ),
      child: SizedBox(
        width: double.infinity,
        height: Responsive.hp(8),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(69),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: Responsive.hp(2), color: AppColors.textColor),
          ),
        ),
      ),
    );
  }
}
