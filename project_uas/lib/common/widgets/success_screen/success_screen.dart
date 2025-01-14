import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/styles/spacing_styles.dart';
import 'package:project_uas/features/authentication/screens/login/login.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subTitle, required this.onPressed});

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: BSpacingStyles.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              Image (
                  image: const AssetImage(BImages.deliveredEmailIllustration),
                  width: BHelperFunctions.screenWidth() * 0.6,
                ), // Image
                const SizedBox(height: BSize.spaceBtwSections),

              /// Title & SubTitle
              Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: BSize.spaceBtwItems),
              Text(subTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: BSize.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Get.to(() => const LoginScreen()), child: const Text(BText.tContinue))),
            ],
          ),
        ),
      ),
    );
  }
}