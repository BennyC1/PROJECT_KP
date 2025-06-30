import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/validators/validators.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key}) ;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(BSize.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(BText.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox (height: BSize.spaceBtwItems),
            Text(BText.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: BSize.spaceBtwSections * 2),

            /// text field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: BValidator.validateEmail,
                decoration: const InputDecoration(labelText: BText.email, prefixIcon: Icon(Iconsax.direct_right)),
              ),
            ), // TextFormField
            const SizedBox(height: BSize.spaceBtwSections),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.sendPasswordResetEmail(), child: const Text(BText.submit))),
          ], 
        ),
      ),         
    );
  }          
}