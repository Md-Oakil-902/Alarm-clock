import 'package:flutter/material.dart';

import '../../common_widgets/next_button.dart';
import '../../common_widgets/onboardingTextBlock.dart';
import '../../common_widgets/skipbutton.dart';
import '../../common_widgets/video_container.dart';
import '../../constants/Strings.dart';
import '../../constants/color.dart';
import '../../helper/responsive.dart';
import 'onboarding_screen2.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Stack(
            children: [
              VideoContainer(
                videoAssetPath: "assets/videos/firstvideo.mp4",
                heightPercentage: 54,
                borderRadiusPercentage: 35,
              ),
              SkipButton(
                onPressed: () {},
              ),
            ],
          ),
          OnboardingTextBlock(
            title: AppStrings.onboardingTitleSecond,
            description: AppStrings.onboardingDescriptionSecond,
          ),
          Spacer(),
          NextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondScreen()),
              );
            },
            text: "Next",
          ),
          SizedBox(height: Responsive.hp(5)),
        ],
      ),
    );
  }
}