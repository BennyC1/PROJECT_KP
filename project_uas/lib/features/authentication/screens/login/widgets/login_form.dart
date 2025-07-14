import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/authentication/controllers/login/login_controller.dart';
import 'package:project_uas/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:project_uas/features/authentication/screens/signup.widgets/signup.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/validators/validators.dart';

class BLoginForm extends StatelessWidget {
  const BLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BSize.spaceBtwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              controller: controller.email,
              validator: (value) => BValidator.validateEmail(value),
              decoration: InputDecoration(prefixIcon: const Icon(Iconsax.direct_right), 
              floatingLabelStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              labelText: BText.email),
            ),
            const SizedBox(height: BSize.spaceBtwInputFields),
        
            Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => BValidator.validateEmptyText('Password', value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: BText.password,
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ), 
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value, 
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)
                )
              ),
            ),
          ),
            const SizedBox(height: BSize.spaceBtwInputFields),
        
            // Remember & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //remember
                Row(
                  children: [
                    Obx(() => Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value)),
                    const Text(BText.rememberMe),
                  ],
                ),
                //forget
                TextButton(onPressed: () => Get.to(() => const ForgetPassword()), child: const Text(BText.forgetPassword)),
              ],
            ),
            const SizedBox(height: BSize.spaceBtwInputFields),
        
            // Signin
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(), child: const Text(BText.signIn))),
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