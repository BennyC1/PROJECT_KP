import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/personalization/controllers/user_controller.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/validators/validators.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Re-Authenticate User')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Email
                TextFormField(
                  controller: controller.verifyEmail,
                  validator: BValidator.validateEmail,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: BText.email),
                ),
                const SizedBox(height: BSize.spaceBtwInputFields),

                /// Password
                Obx (
                  () => TextFormField(
                    obscureText: controller.hidePassword. value,
                    controller: controller. verifyPassword,
                    validator: (value) => BValidator.validateEmptyText('Password', value),
                    decoration: InputDecoration(
                      labelText: BText.password,
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                        icon: const Icon(Iconsax.eye_slash)
                      ),
                    ),
                  ),
                ), 
                const SizedBox(height: BSize.spaceBtwSections),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () => controller.reAuthenticateEmailAndPasswordUser(), child: const Text('Verify')),
                ),
              ],
            )
          )
        )
      )
    );
  }
}

