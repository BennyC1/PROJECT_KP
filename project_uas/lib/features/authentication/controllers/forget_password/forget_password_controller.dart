import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/helpers/network_manager.dart';
import 'package:project_uas/utils/popups/full_screen_loader.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  // Variable
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  //Send Reset pPassword Email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      BFullScreenLoader.openLoadingDialog('Processing your request...', BImages.docerAnimation);

      // Internet Connection Checker
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {BFullScreenLoader.stopLoading(); return;}

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        BFullScreenLoader.stopLoading();
        return;
      }

      // Send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());
      
      // Remove Loader
      BFullScreenLoader.stopLoading();

      // Show Success
      BLoaders.successSnackBar(title: 'Email Reset', message: 'Email Link Sent to Reset Your Password'.tr);

      // Redirect
      Get.to(() => ResetPassword(email: email.text.trim()));

    } catch (e) {
      // Remove Loader
      BFullScreenLoader.stopLoading();
      BLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  } 
  
  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      BFullScreenLoader.openLoadingDialog('Processing your request...', BImages.docerAnimation);

      // Internet Connection Checker
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {BFullScreenLoader.stopLoading(); return;}

      // Send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);
      
      // Remove Loader
      BFullScreenLoader.stopLoading();

      // Show Success
      BLoaders.successSnackBar(title: 'Email Reset', message: 'Email Link Sent to Reset Your Password'.tr);

    } catch (e) {
      // Remove Loader
      BFullScreenLoader.stopLoading();
      BLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}