
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/features/personalization/controllers/user_controller.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/helpers/network_manager.dart';
import 'package:project_uas/utils/popups/full_screen_loader.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class LoginController extends GetxController { 
  
  /// Variables 
  final rememberMe = true.obs; 
  final hidePassword = true.obs; 
  final localStorage = GetStorage(); 
  final email = TextEditingController(); 
  final password = TextEditingController(); 
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController =  Get.put(UserController()); 

  @override
  void onInit() {
    super.onInit();
    forceGoogleLogout(); // ⬅️ panggil di awal controller hidup
  }

  void forceGoogleLogout() async {
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      debugPrint("✅ Google & Firebase SignOut berhasil di halaman login");
    }
  }
  
  /// Email and Password SignIn 
  Future<void> emailAndPasswordSignIn() async { 
    try {
      // Start Loading 
      BFullScreenLoader.openLoadingDialog('Logging you in...', BImages.docerAnimation); 
      
      // Check Internet Connectivity 
      final isConnected = await NetworkManager.instance.isConnected(); 
      if (!isConnected) { 
        BFullScreenLoader.stopLoading(); 
        return; 
      }

      // Form Validation 
      if (!loginFormKey.currentState!.validate()) { 
        BFullScreenLoader.stopLoading(); 
        return; 
      } 

      // Save Data if Remember Me is selected 
      if (rememberMe.value) { 
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim()); 
        localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim()); 
      } 

      // Login user using EMail & Password Authentication 
      // ignore: unused_local_variable
      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim()); 

      // Remove Loader 
      BFullScreenLoader.stopLoading(); 

      // Redirect 
      AuthenticationRepository.instance.screenRedirect(); 
    } catch (e) { 
      BFullScreenLoader.stopLoading(); 
      BLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
  
  /// Google SignIn Authentication 
  Future<void> googleSignIn() async { 
    try { 
      // Start Loading 
      BFullScreenLoader.openLoadingDialog('Logging you in...', BImages.docerAnimation);

      // Check Internet Connectivity 
      final isConnected = await NetworkManager.instance.isConnected(); 
      if (!isConnected) { 
        BFullScreenLoader.stopLoading(); 
        return; 
      } 

      // Google Authentication 
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle(); 

      // Save User Record 
      await userController.saveUserRecord(userCredentials); 

      // Remove Loader 
      BFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      //Remove Loader
      BFullScreenLoader.stopLoading();
      BLoaders.errorSnackBar(title: 'Oh Snap',message : e.toString());
    }
  }
}