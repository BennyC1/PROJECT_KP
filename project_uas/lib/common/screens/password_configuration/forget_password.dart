import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/screens/password_configuration/reset_password.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key}) ;
  @override
  Widget build(BuildContext context) {
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
            TextFormField(
            decoration: const InputDecoration(labelText: BText.email, prefixIcon: Icon(Iconsax.direct_right)),
            ), // TextFormField
            const SizedBox(height: BSize.spaceBtwSections),
            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => Get.to(() => const ResetPassword()), child: const Text(BText.submit))),
          ], 
        ),
      ),         
    );
  }          
}