import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/features/authentication/screens/login/login.dart';
import 'package:project_uas/utils/constants/sized.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => Get.offAll(() => const LoginScreen()), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [
              /// image
              Image 
              
              /// title dan sub title
            
              /// buttons
            ],
          ),),
      ),
    );
  }
}