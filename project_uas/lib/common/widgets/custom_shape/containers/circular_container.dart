import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/colors.dart';

class BCircularContainer extends StatelessWidget {
  const BCircularContainer({
    super.key, 
    this.child, 
    this.width = 400, 
    this.height = 400, 
    this.radius = 400, 
    this.padding = 0, 
    this.backgroundColor = BColors.white,
  });

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container (
      padding: const EdgeInsets.all(0),
      child: Stack(
        children: [
          Container (
            width: 400,
            height: 400,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(480),
              color: BColors.textWhite.withOpacity(0.1),
            ),
            child: child, 
          ), 
        ],
      ),
    );
  }
}