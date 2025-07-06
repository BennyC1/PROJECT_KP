import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_uas/data/user/user_repository.dart';
import 'package:project_uas/features/authentication/screens/login/login.dart';
import 'package:project_uas/features/authentication/controllers/onboarding/onboarding.dart';
import 'package:project_uas/features/authentication/screens/signup.widgets/verify_email.dart';
import 'package:project_uas/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:project_uas/utils/exceptions/firebase_exceptions.dart';
import 'package:project_uas/utils/exceptions/format_exceptions.dart';
import 'package:project_uas/utils/exceptions/platform_exceptions.dart';
import 'package:project_uas/utils/local_storage/storage_utility.dart';

import '../../navigation_menu.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  // Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  /// Called from main.dort on opp Launch
  @override
  void onReady() {
    FlutterNativeSplash.remove ();
    screenRedirect();
  }
    
  /// Function to Show Relevant Screen
  void screenRedirect() async {
    final user = _auth.currentUser;
    final userModel = await UserRepository.instance.fetchUserDetails();
    Get.put(userModel);
    
    if(user != null) {
      // initialize User spesific storage
      await BLocalStorage.init(user.uid);

      // IF USER EMAIL IS VERIFIED
      if(user.emailVerified){
        Get.offAll(() => const NavigationMenu());
      } else{
        Get.offAll(() => VerifyEmailScreen (email: _auth.currentUser?.email));
    }
  } else  {
      // Local Storage
      deviceStorage.writeIfNull('IsFirstTime', true);
      deviceStorage.read('IsFirstTime') != true 
        ? Get.offAll(() => const LoginScreen()) 
        : Get.offAll(const OnBoardingScreen());
    }
  }
  // login
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      // 🔁 Force sign out Google session (hindari user Google "tersangkut")
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
        await googleSignIn.signOut();
      }

      // 🔁 Sign out Firebase to clear session before login baru
      await FirebaseAuth.instance.signOut();

      // ✅ Login email-password
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      // ⬇️ Paksa Firebase refresh user session setelah login
      await FirebaseAuth.instance.currentUser?.reload();

      // (Optional) Debug siapa yang sedang login
      debugPrint("✅ Login Manual: ${FirebaseAuth.instance.currentUser?.email}");

      return credential;
    } on FirebaseAuthException catch (e) {
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BFormatException();
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // email register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BFormatException();
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // email verify
  Future<void> sendEmailVerification() async {
    try {
      return _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BFormatException();
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // forget password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BFormatException();
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // reaunthetication user
  Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
    try {
      // Create credentials
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      // Re authenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BFormatException();
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // google auth
  Future<UserCredential?> signInWithGoogle() async { 
    try { 
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        // Optional: force code refresh if you're using advanced flows
        // forceCodeForRefreshToken: true,
      );

      // ⬅️ Wajib signOut dulu untuk memaksa user pilih akun ulang
      await googleSignIn.signOut();

      final GoogleSignInAccount? userAccount = await googleSignIn.signIn();
      if (userAccount == null) return null;

      final GoogleSignInAuthentication googleAuth = await userAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) { 
      throw BFirebaseAuthException(e.code).message; 
    } on FirebaseException catch (e) { 
      throw BFirebaseException(e.code).message; 
    } on FormatException catch(_) { 
      throw const BFormatException(); 
    } on PlatformException catch (e) { 
      throw BPlatformException(e.code).message; 
    } catch (e) { 
      if (kDebugMode) print('Something went wrong: $e'); 
      return null;   
    }
  }
      
  // logout user
  Future<void> logout() async {
    try {
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BFormatException();
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // delete user
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BFormatException();
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
