import 'package:get/get.dart';
import 'package:project_uas/src/fitur/authentication/screens/login/login.dart';


class SplashScreenControllers extends GetxController {
  static SplashScreenControllers get find => Get.find();

  RxBool animate = false.obs;

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(Duration(milliseconds: 5000));
    Get.to(const LoginScreen());
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }
}