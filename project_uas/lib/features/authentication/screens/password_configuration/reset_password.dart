import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:project_uas/features/authentication/screens/login/login.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets. all(BSize.defaultSpace),
          child: Column(
            children: [
              // Image
              Image (
                  image: const AssetImage(BImages.deliveredEmailIllustration),
                  width: BHelperFunctions.screenWidth() * 0.6,
                ), 
              const SizedBox(height: BSize.spaceBtwSections),

              /// Email, Title & SubTitle
              Text(email, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: BSize.spaceBtwItems),
              Text(BText.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: BSize.spaceBtwItems),
              Text(BText.changeYourPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: BSize.spaceBtwSections),

              // button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Get.offAll(() => const LoginScreen()), child: const Text(BText.done))),
              const SizedBox(height: BSize.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => ForgetPasswordController.instance.resendPasswordResetEmail(email), child: const Text(BText.resendEmail))),
            ],
          ), 
        ), 
      ), 
    ); 
  }
}