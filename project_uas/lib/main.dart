import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  // widget binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Getx local storage
  await GetStorage.init();

  // wait splash until other item  load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // firebase & authentication
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );
   
  runApp(const App());
}
