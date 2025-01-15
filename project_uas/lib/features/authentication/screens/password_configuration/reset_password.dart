import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))],
      ),// AppBar
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

              /// Title & SubTitle
              Text(BText.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: BSize.spaceBtwItems),
              Text(BText.changeYourPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: BSize.spaceBtwSections),

              // button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: const Text(BText.done))),
              const SizedBox(height: BSize.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: const Text(BText.resendEmail))),
            ],
          ), 
        ), 
      ), 
    ); 
  }
}