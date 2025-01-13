import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/styles/spacing_styles.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: BSpacingStyles.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    height: 150,
                    image: AssetImage(dark ? BImages.LightAppLogo : BImages.darkAppLogo),
                  ),
                  Text(BText.LoginTitle, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: BSize.sm),
                  Text(BText.LoginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              // Form
              Form(
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
                          TextButton(onPressed: () {}, child: const Text(BText.forgetPassword)),
                        ],
                      ),
                      const SizedBox(height: BSize.spaceBtwInputFields),
                  
                      // Signin
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text(BText.signIn))),
                      const SizedBox(height: BSize.spaceBtwItems),

                      // Create Account
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text(BText.createAccount))),
                      const SizedBox(height: BSize.spaceBtwSections),
                    ],
                  ),
                ),
              ),

              // divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(color: dark ? BColors.darkGrey: BColors.grey, thickness: 0.5, indent: 60, endIndent: 5),
                ],)
            ],
          ),
        ),   
      ),
    );
  }
}