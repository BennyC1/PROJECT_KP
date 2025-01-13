import 'package:flutter/material.dart';
import 'package:project_uas/src/utils/constants/sized.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: BSize.appBarHeight,
            left: BSize.defaultSpace,
            bottom: BSize.defaultSpace,
            right: BSize.defaultSpace,
          ),
        ),
      ),
    );
  }
}