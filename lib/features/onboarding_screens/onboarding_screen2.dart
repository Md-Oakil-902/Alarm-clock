import 'package:flutter/material.dart';

import '../../common_widgets/next_button.dart';
import '../../common_widgets/onboardingTextBlock.dart';
import '../../common_widgets/skipbutton.dart';
import '../../common_widgets/video_container.dart';
import '../../constants/Strings.dart';
import '../../constants/color.dart';
import '../../helper/responsive.dart';
import 'onboarding_screen3.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
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
                videoAssetPath: "assets/videos/secondvideo.mp4",
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
                MaterialPageRoute(builder: (context) => ThirdScreen()),
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