import 'package:flutter/material.dart';
import 'package:project_uas/utils/theme/custom_themes/text_theme.dart';
import 'package:project_uas/utils/theme/custom_themes/elevated_button_theme.dart';

class AppTheme {

  AppTheme._();

  static ThemeData LightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light, 
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: BElevatedButtonTheme.lightElevatedButtonTheme,
  );
  
  static ThemeData DarkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark, 
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: BElevatedButtonTheme.darkElevatedButtonTheme,
  );
}