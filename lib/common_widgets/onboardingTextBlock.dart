import 'package:flutter/material.dart';

import '../constants/typography.dart';
import '../helper/responsive.dart';


class OnboardingTextBlock extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingTextBlock({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.large,
          ),
          SizedBox(height: Responsive.hp(2)),
          Text(
            description,
            style: AppTypography.medium,
          ),
        ],
      ),
    );
  }
}
