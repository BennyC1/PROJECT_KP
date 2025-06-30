import 'package:flutter/material.dart';
import 'package:project_uas/features/authentication/controllers/onboarding/controllers.onboarding/onboarding_controller.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/device/device_utility.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingDotNagivation extends StatelessWidget {
  const OnBoardingDotNagivation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = BHelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: BDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: BSize.defaultSpace,
      child: SmoothPageIndicator(
        count: 3,
        controller : controller.pageController,
        onDotClicked: controller.dotNavigationClick, 
        effect: ExpandingDotsEffect(activeDotColor: dark ? BColors.light: BColors.dark, dotHeight: 6),
        ),
    );
  }
}