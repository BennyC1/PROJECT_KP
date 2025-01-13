import 'package:flutter/material.dart';
import 'package:project_uas/src/fitur/authentication/screens/splash_screen/splash_screen.dart';
import 'package:project_uas/src/utils/theme/theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.LightTheme,
      darkTheme: AppTheme.DarkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}