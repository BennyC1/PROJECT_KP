import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:project_uas/features/authentication/screens/signup.widgets/signup.dart';
import 'package:project_uas/navigation_menu.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';

class BLoginForm extends StatelessWidget {
  const BLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BSize.spaceBtwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: BText.email),
            ),
            const SizedBox(height: BSize.spaceBtwInputFields),
        
            // Password
            TextFormField(
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.password_check), labelText: BText.password, suffixIcon: Icon(Iconsax.eye_slash)
              ),
            ),
            const SizedBox(height: BSize.spaceBtwInputFields / 2),
        
            // Remember & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //remember
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(BText.rememberMe),
                  ],
                ),
                //forget
                TextButton(onPressed: () => Get.to(() => const ForgetPassword()), child: const Text(BText.forgetPassword)),
              ],
            ),
            const SizedBox(height: BSize.spaceBtwInputFields),
        
            // Signin
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.to(() => const NavigationMenu()), child: const Text(BText.signIn))),
            const SizedBox(height: BSize.spaceBtwItems),
    
            // Create Account
            SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Get.to(() => const SignupScreen()), child: const Text(BText.createAccount))),
            const SizedBox(height: BSize.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}