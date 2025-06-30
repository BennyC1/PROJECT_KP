import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/device/device_utility.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BSearchContainer extends StatelessWidget {
  const BSearchContainer({
    super.key, 
    required this.text, 
    this.icon = Iconsax.search_normal, 
    this.showBackground = true, 
    this.showBorder = true,
    this.padding = const EdgeInsets.symmetric(horizontal: BSize.defaultSpace),
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap:  () {},
      child: Padding (
        padding: padding,
        child: Container(
          width: BDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(BSize.md),
          decoration: BoxDecoration (
            color: showBackground ? dark ? BColors.dark : BColors.light : Colors.transparent,
            borderRadius: BorderRadius.circular(BSize.cardRadiusLg),
            border: showBorder ? Border.all(color: BColors.grey) : null,
          ), 
        child: Row(
          children: [
            Icon(icon , color: BColors.darkerGrey),
            const SizedBox(width: BSize.spaceBtwItems),
            Text(text, style: Theme.of(context).textTheme.bodySmall),
            ]
          ),
        ),
      ),
    );
  }
}
