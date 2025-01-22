import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/data/repositories/authentication/repositories_authentication.dart';
import 'package:project_uas/data/user/user_repository.dart';
import 'package:project_uas/features/authentication/screens/signup.widgets/verify_email.dart';
import 'package:project_uas/features/personalization/models/user_model.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/helpers/network_manager.dart';
import 'package:project_uas/utils/popups/full_screen_loader.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get. find();

  /// Variables
  final hidePassword = true.obs; // observable hide/show password
  final privacyPolicy = true.obs; // observable hide/show password
  final email = TextEditingController(); // Controller for email input
  final lastName = TextEditingController(); // Controller for Last name input
  final username = TextEditingController(); // Controller for username input
  final password = TextEditingController (); // Controller for password input
  final firstName = TextEditingController(); // Controller for first name input
  final phoneNumber = TextEditingController(); // Controller for phone number input
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>(); // Form key for form validation

  // SIGNUP
  Future<void> signup() async {
    try {
      // Start Loading
      BFullScreenLoader.openLoadingDialog('We are processing your information ... ', BImages.docerAnimation);

      // check internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // Remove Loader
        BFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if(!signupFormKey.currentState!.validate()) {
        // Remove Loader
        BFullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        BLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use:',
          );
      return;
      }

      // Register user in the Firebase Authentication & Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());
  
      // Save Authenticated user data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Remove Loader
      BFullScreenLoader.stopLoading();

      // Show Success Message
      BLoaders.successSnackBar (title: 'Congratulations', message: 'Your account has been created! Verif email to continue.');

      // Move to Verify Email, Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
    } catch (e) {
      // Remove Loader
      BFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      BLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());  
    }
  }
}

