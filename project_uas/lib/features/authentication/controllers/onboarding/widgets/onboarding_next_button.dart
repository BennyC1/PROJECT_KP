import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/authentication/controllers/onboarding/controllers.onboarding/onboarding_controller.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/device/device_utility.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return Positioned(
      right: BSize.defaultSpace,
      bottom: BDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(shape: const CircleBorder(), backgroundColor: dark ? BColors.primary : Colors.black), 
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}