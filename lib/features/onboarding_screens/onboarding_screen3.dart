import 'package:flutter/material.dart';

import '../../common_widgets/next_button.dart';
import '../../common_widgets/onboardingTextBlock.dart';
import '../../common_widgets/skipbutton.dart';
import '../../common_widgets/video_container.dart';
import '../../constants/Strings.dart';
import '../../constants/color.dart';
import '../../helper/responsive.dart';
import 'location_fetching_screen.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
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
                videoAssetPath: "assets/videos/thirdvideo.mp4",
                heightPercentage: 54,
                borderRadiusPercentage: 35,
              ),
              SkipButton(onPressed: () {}),
            ],
          ),
          OnboardingTextBlock(
            title: AppStrings.onboardingTitleThird,
            description: AppStrings.onboardingDescriptionThird,
          ),
          Spacer(),
          NextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationFetchingScreen(),
                ),
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
