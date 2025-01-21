import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: BText.appName,
      themeMode: ThemeMode.system,
      theme: AppTheme.LightTheme,
      darkTheme: AppTheme.DarkTheme,
      debugShowCheckedModeBanner: false,
      // initialBinding: GeneralBindings(),
      home: const Scaffold(backgroundColor: BColors.primary, body: Center(child: CircularProgressIndicator(color: Colors.white))),
    );
  }
}
