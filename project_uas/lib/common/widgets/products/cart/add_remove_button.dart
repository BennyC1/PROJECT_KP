import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/icons/circular_icon.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BProductQuantityWithAddRemoveButton extends StatelessWidget {
  const BProductQuantityWithAddRemoveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BCircularIcon(
          icon: Iconsax. minus,
          width: 32,
          height: 32,
          size: BSize.md,
          color: BHelperFunctions. isDarkMode (context) ? BColors.white : BColors.black,
          backgroundcolor: BHelperFunctions . isDarkMode(context) ? BColors.darkerGrey : BColors.light,
        ),
        const SizedBox(width: BSize. spaceBtwItems),
        Text('1', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: BSize.spaceBtwItems),

        const BCircularIcon(
          icon: Iconsax.add,
          width: 32,
          height: 32,
          size: BSize .md,
          color: BColors.white,
          backgroundcolor: BColors.primary,
        ),
      ]
    );
  }
}

