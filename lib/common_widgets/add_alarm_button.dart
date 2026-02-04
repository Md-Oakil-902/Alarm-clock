

import 'dart:ui';

import '../constants/color.dart';
import '../helper/responsive.dart';
import 'package:flutter/material.dart';

class AddAlarmButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddAlarmButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.wp(5),
        vertical: Responsive.hp(3),
      ),
      child: SizedBox(
        width: double.infinity,
        height: Responsive.hp(7),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonBackgroundColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Responsive.hp(2)),
            ),
            elevation: 3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: Responsive.hp(2.5)),
              SizedBox(width: Responsive.wp(2)),
              Text(
                "Add Alarm",
                style: TextStyle(
                  fontSize: Responsive.hp(2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}