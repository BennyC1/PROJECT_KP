import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/authentication/controllers/signup/signup_controller.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/validators/validators.dart';

class BFormSignup extends StatelessWidget {
  const BFormSignup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => BValidator.validateEmptyText('First name', value),
                  expands: false,
                  decoration: InputDecoration(
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                    labelText: BText.firstName, prefixIcon: const Icon(Iconsax.user)
                  ),
                ),
              ),
              const SizedBox(width: BSize.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) => BValidator.validateEmptyText('Last name', value),
                  expands: false,
                  decoration: InputDecoration(
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                    labelText: BText.lastName, prefixIcon: const Icon(Iconsax.user)
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: BSize.spaceBtwInputFields),
    
          // username (capek)
          TextFormField(
            controller: controller.username,
            validator: (value) => BValidator.validateEmptyText('Username', value),
            expands: false,
            decoration: InputDecoration(
              floatingLabelStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              labelText: BText.username, prefixIcon: const Icon(Iconsax.user_edit)
            ),
          ),
          const SizedBox(height: BSize.spaceBtwInputFields),
    
          // email (capek)
          TextFormField(
            controller: controller.email,
            validator: (value) => BValidator.validateEmail(value),
            decoration: InputDecoration(
              floatingLabelStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              labelText: BText.email, prefixIcon: const Icon(Iconsax.direct)
            ),
          ),
          const SizedBox(height: BSize.spaceBtwInputFields),
    
          // phone (capek)
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => BValidator.validatePhoneNumber(value),
            decoration: InputDecoration(
              floatingLabelStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              labelText: BText.phoneNo, prefixIcon: const Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: BSize.spaceBtwInputFields),
    
          // Password (capek)
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => BValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: BText.password, 
                prefixIcon: const Icon(Iconsax.password_check),
                floatingLabelStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value, 
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)
                )
              ),
            ),
          ),
          const SizedBox(height: BSize.spaceBtwInputFields),
    
          //signup buton
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () => controller.signup(), 
            child: const Text(BText.createAccount)),
          ),
        ],
      ),
    );
  }
}