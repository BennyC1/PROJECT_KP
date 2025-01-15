import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/screens/signup.widgets/verify_email.dart';
import 'package:project_uas/common/screens/signup.widgets/widgets/terms_condition_checkbox.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';

class BFormSignup extends StatelessWidget {
  const BFormSignup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(labelText: BText.firstName, prefixIcon: Icon(Iconsax.user)
                  ),
                ),
              ),
              const SizedBox(width: BSize.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(labelText: BText.lastName, prefixIcon: Icon(Iconsax.user)
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: BSize.spaceBtwInputFields),
    
          // username (capek)
          TextFormField(
            expands: false,
            decoration: const InputDecoration(labelText: BText.username, prefixIcon: Icon(Iconsax.user_edit)
            ),
          ),
          const SizedBox(height: BSize.spaceBtwInputFields),
    
          // email (capek)
          TextFormField(
            decoration: const InputDecoration(labelText: BText.email, prefixIcon: Icon(Iconsax.direct)
            ),
          ),
          const SizedBox(height: BSize.spaceBtwInputFields),
    
          // phone (capek)
          TextFormField(
            decoration: const InputDecoration(labelText: BText.phoneNo, prefixIcon: Icon(Iconsax.call)
            ),
          ),
          const SizedBox(height: BSize.spaceBtwInputFields),
    
          // Password (capek)
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: BText.password, 
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash)
            ),
          ),
          const SizedBox(height: BSize.spaceBtwInputFields),
    
          // terms&conditions
          const BTermConditionCheckbox(),
          const SizedBox(height: BSize.spaceBtwSections),
    
          //signup buton
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.to(() => const VerifyEmailScreen() ), child: const Text(BText.createAccount)),
          ),
        ],
      ),
    );
  }
}