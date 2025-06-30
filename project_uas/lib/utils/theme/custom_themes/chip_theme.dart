import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/colors.dart';

class BChipTheme {
  BChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: BColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: Colors.black),
    selectedColor: BColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    checkmarkColor: BColors.white,
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    disabledColor: BColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: Colors.white),
    selectedColor: BColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    checkmarkColor: BColors.white,
  );
}