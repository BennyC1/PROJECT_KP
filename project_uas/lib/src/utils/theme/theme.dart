import 'package:flutter/material.dart';
import 'package:project_uas/src/utils/theme/widget_theme/text_theme.dart';

class AppTheme {

  AppTheme._();

  static ThemeData LightTheme = ThemeData(
    brightness: Brightness.light, 
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
  );
  
  static ThemeData DarkTheme = ThemeData(
    brightness: Brightness.dark, 
    textTheme: TTextTheme.darkTextTheme,
  );
}