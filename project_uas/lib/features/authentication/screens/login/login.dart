import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/styles/spacing_styles.dart';
import 'package:project_uas/common/widgets.login_signup/form_divider.dart';
import 'package:project_uas/common/widgets.login_signup/sosial_buttons.dart';
import 'package:project_uas/features/authentication/screens/login/widgets/login_form.dart';
import 'package:project_uas/features/authentication/screens/login/widgets/login_header.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: BSpacingStyles.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo Title
              const BLoginHeader(),

              // Form
              const BLoginForm(),

              // divider
              BFormDivider(dividerText: BText.orSignInWith.capitalize!),
              const SizedBox(height: BSize.spaceBtwSections),

              // footer
              const BSosialButtons()
            ],
          ),
        ),   
      ),
    );
  }
}


