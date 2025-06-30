import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BSpacingStyles {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: BSize.appBarHeight,
    left: BSize.defaultSpace,
    bottom: BSize.defaultSpace,
    right: BSize.defaultSpace,
  );
}