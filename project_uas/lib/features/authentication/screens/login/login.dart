import 'package:flutter/material.dart';
import 'package:project_uas/common/styles/spacing_styles.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: BSpacingStyles.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            ],
          ),      
        ),
      ),
    );
  }
}