import 'package:flutter/material.dart';
import 'package:project_uas/features/authentication/controllers.onboarding/onboarding_controller.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: BDeviceUtils.getAppBarHeight(),
      right: BSize.defaultSpace,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(), child: const Text('Skip'),
        ),
    );
  }
}