import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BSosialButtons extends StatelessWidget {
  const BSosialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: BColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {}, 
            icon: const Image(
              width: BSize.iconMd,
              height: BSize.iconMd,
              image: AssetImage(BImages.google),
            ),
          ),
        ),
        const SizedBox(width: BSize.spaceBtwItems),
        Container(
          decoration: BoxDecoration(border: Border.all(color: BColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {}, 
            icon: const Image(
              width: BSize.iconMd,
              height: BSize.iconMd,
              image: AssetImage(BImages.facebook),
            ),
          ),
        ),
      ],
    );
  }
}