import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BCircularIcon extends StatelessWidget {
  const BCircularIcon({
    super.key,
    required this.icon,
    this.width,
    this.height,
    this.size = BSize.Lg,
    this.onPressed,
    this.color,
    this.backgroundcolor,
    });
      
    final double? width, height, size;
    final IconData icon;
    final Color? color;
    final Color? backgroundcolor;
    final VoidCallback? onPressed;

    @override
    Widget build(BuildContext context) {
      return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundcolor != null
        ? backgroundcolor!
        : BHelperFunctions.isDarkMode(context)
        ? BColors.black.withOpacity(0.9)
        : BColors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(100),
      ), 
      child: IconButton(onPressed: onPressed, icon: Icon(icon, color: color, size: size)),
    );
  }
}