import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/features/authentication/controllers.onboarding/onboarding_controller.dart';
import 'package:project_uas/features/authentication/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:project_uas/features/authentication/onboarding/widgets/onboarding_next_button.dart';
import 'package:project_uas/features/authentication/onboarding/widgets/onboarding_page.dart';
import 'package:project_uas/features/authentication/onboarding/widgets/onboarding_skip.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/text_string.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          //horizontal
          PageView (
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: BImages.onBoardingImage1,
                title: BText.onBoardingTitle1,
                subTitle: BText.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: BImages.onBoardingImage2,
                title: BText.onBoardingTitle2,
                subTitle: BText.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: BImages.onBoardingImage3,
                title: BText.onBoardingTitle3,
                subTitle: BText.onBoardingSubTitle3,
              ),
            ]
          ),

          // Skip 
          const OnBoardingSkip(),

          // bar 3 bawah
          const OnBoardingDotNagivation(),

          //
          const OnBoardingNextButton()
        ]
      ),
    );
  }
}







