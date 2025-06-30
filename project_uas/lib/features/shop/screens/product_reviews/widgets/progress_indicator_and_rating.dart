
import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/device/device_utility.dart';

class BRatingProgressIndicator extends StatelessWidget {
  const BRatingProgressIndicator({
  super.key,
  required this. text, 
  required this. value,
  });

  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(text, style: Theme. of(context). textTheme.bodyMedium)),
        Expanded (
          flex: 11,
          child: SizedBox(
            width: BDeviceUtils.getScreenWidth(context) * 0.8,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 11,
              backgroundColor: BColors.grey,
              borderRadius: BorderRadius.circular(7),
              valueColor: const AlwaysStoppedAnimation(BColors.primary),
            ),
          ),
        )
      ]
    );
  }
}
