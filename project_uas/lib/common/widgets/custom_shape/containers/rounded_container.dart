import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BRoundedContainer extends StatelessWidget {
  const BRoundedContainer ({
    super.key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this. showBorder = false,
    this.radius = BSize.cardRadiusLg,
    this.backgroundcolor = BColors.white,
    this.borderColor = BColors.borderPrimary,
    });

    final double? width;
    final double? height;
    final double radius;
    final Widget? child;
    final bool showBorder;
    final Color borderColor;
    final Color backgroundcolor;
    final EdgeInsetsGeometry? padding;
    final EdgeInsetsGeometry? margin;

    @override
    Widget build(BuildContext context) {
      return Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundcolor,
          borderRadius: BorderRadius.circular(radius),
          border: showBorder ? Border.all(color: borderColor) : null,
        ),
        child: child,
      );
    }
}
