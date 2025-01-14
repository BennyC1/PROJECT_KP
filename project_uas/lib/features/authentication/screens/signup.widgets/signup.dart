import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets.login_signup/form_divider.dart';
import 'package:project_uas/common/widgets.login_signup/sosial_buttons.dart';
import 'package:project_uas/features/authentication/screens/signup.widgets/widgets/signup_form.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Text(BText.signupTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: BSize.spaceBtwSections),

              // form
              BFormSignup(),
              const SizedBox(height: BSize.spaceBtwSections),

              /// divider
              BFormDivider(dividerText: BText.orSignUpWith.capitalize!),
              const SizedBox(height: BSize.spaceBtwSections),

              // sosial button
              const BSosialButtons(),

            ],
          ),
        ),
      ),
    );
  }
}

