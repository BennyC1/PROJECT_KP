import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/success_screen/success_screen.dart';
import 'package:project_uas/data/repositories/authentication/repositories_authentication.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  /// Send Email Whenever Verify Screen appears & Set Timer for auto redirect.
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  /// Send Email Verification Link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      BLoaders.successSnackBar(title:'Email Sent', message: 'Please Check your inbox and verify your email.');
      } catch (e) {
      BLoaders.errorSnackBar(title:"Oh Snap!", message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {   
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        final user = FirebaseAuth.instance.currentUser;
        if (user?.emailVerified ?? false) {
          timer.cancel();
          Get.off(
            () => SuccessScreen(
              image: BImages.successfullyRegisterAnimation ,
              title: BText.yourAccountCreatedTitle,
              subTitle: BText.yourAccountCreatedSubTitle,
              onPressed: () => AuthenticationRepository.instance.screenRedirect(),
            ),
          );
        }
      }
    );
  }

  /// Manually Check if Email Verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          image: BImages.successfullyRegisterAnimation,
          title: BText.yourAccountCreatedTitle,
          subTitle: BText.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        )
      );
    }
  }
}