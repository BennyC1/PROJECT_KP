import 'package:flutter/material.dart';
import 'package:project_uas/utils/theme/custom_themes/appbar_theme.dart';
import 'package:project_uas/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:project_uas/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:project_uas/utils/theme/custom_themes/chip_theme.dart';
import 'package:project_uas/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:project_uas/utils/theme/custom_themes/text_field_theme.dart';
import 'package:project_uas/utils/theme/custom_themes/text_theme.dart';
import 'package:project_uas/utils/theme/custom_themes/elevated_button_theme.dart';

class AppTheme {

  AppTheme._();

  static ThemeData LightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light, 
    primaryColor: Colors.blue,
    textTheme: BTextTheme.lightTextTheme,
    chipTheme: BChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: BAppBarTheme.lightAppBarTheme,
    checkboxTheme: BCheckboxTheme.lightCheckBoxTheme,
    bottomSheetTheme: BBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: BElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: BOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: BTextFormFieldTheme.lightInputDecorationTheme,
  );
  
  static ThemeData DarkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark, 
    primaryColor: Colors.blue,
    textTheme: BTextTheme.darkTextTheme,
    chipTheme: BChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: BAppBarTheme.darkAppBarTheme,
    checkboxTheme: BCheckboxTheme.darkCheckBoxTheme,
    bottomSheetTheme: BBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: BElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: BOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: BTextFormFieldTheme.darkInputDecorationTheme,
  );
}