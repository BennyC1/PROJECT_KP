import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/features/authentication/controllers/signup/verify_email_controller.dart';
import 'package:project_uas/features/authentication/screens/signup.widgets/signup.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, 
  this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => AuthenticationRepository.instance.logout(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [
              /// image
              Image (
                  image: const AssetImage(BImages.deliveredEmailIllustration),
                  width: BHelperFunctions.screenWidth() * 0.6,
              ), 
              const SizedBox(height: BSize.spaceBtwSections),

              /// Title & SubTitle
              Text(BText.confirmEmail, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: BSize.spaceBtwItems),
              Text(email ?? '', style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
              const SizedBox(height: BSize.spaceBtwItems),
              Text(BText.confirmEmailSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: BSize.spaceBtwSections),

              /// Buttons
              SizedBox(
                width: double.infinity, 
                child: ElevatedButton(
                  onPressed:  () => Get.offAll(const SignupScreen()), 
                  child: const Text('Cancel'))),
              const SizedBox(height: BSize.spaceBtwItems),
              SizedBox(width: double.infinity, child: TextButton(onPressed: () => controller.sendEmailVerification(), child: const Text(BText.resendEmail))),        
            ],
          ),
        ),
      ),
    );
  }
}