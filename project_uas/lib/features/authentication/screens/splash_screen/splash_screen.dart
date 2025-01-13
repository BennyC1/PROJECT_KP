import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/utils/constants/color.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/features/authentication/controllers/splash_screen_controllers.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final splashController = Get.put(SplashScreenControllers());

  @override
  Widget build(BuildContext context) {
    splashController.startAnimation();
    return Scaffold(
      body: Stack(
        children: [
          Obx( () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? 0 : -30,
              left: splashController.animate.value ? 0 : -30,
              height: 80,
              child:  Image(image: AssetImage(TopSplashImage)),
              ),
          ),
          Obx ( () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: 80,
              height: 200,
              left: splashController.animate.value ? DefaultSize : -80,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1600),
                opacity: splashController.animate.value ?  1 : 0,
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppName, style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(AppTagLine, style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ), 
            ),
          ),
          Obx( () =>  AnimatedPositioned(
              duration: const Duration(milliseconds: 2400),
              bottom: splashController.animate.value ? 200 : 0,
              right: 23,
              height: 120,
              child : AnimatedOpacity(
                duration: const Duration(milliseconds: 2000),
                opacity: splashController.animate.value ? 1 : 0,
                child:  Image(image: AssetImage(SplashImage)),
                )
              ),
          ),
          Obx ( () =>  AnimatedPositioned(
              duration: const Duration(milliseconds: 2400),
              bottom: splashController.animate.value ? 40 : 0,
              right: DefaultSize,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2400),
                opacity: splashController.animate.value ? 1 : 0,
                child: Container(
                  width: SplashContainerSize,
                  height: SplashContainerSize,  
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: PrimaryColor,
                  ),
                ),
              ),     
            ),
          ),
        ],
      ),
    );
  }
  
}