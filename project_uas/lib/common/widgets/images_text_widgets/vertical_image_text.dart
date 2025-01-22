import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BVerticalImageText extends StatelessWidget {
  const BVerticalImageText({
    super.key, 
    required this.image, 
    required this.title, 
    this.textColor = BColors.white, 
    this.backgroundColor, 
    this.onTap,
  });  

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: BSize.spaceBtwItems),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(BSize.sm),
              decoration: BoxDecoration(
                color: backgroundColor ?? (dark ? BColors.black : BColors.white),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image(image: AssetImage(image), fit: BoxFit.cover, color: dark ? BColors.white : BColors.dark),
              ),
            ),
            const SizedBox(height: BSize.spaceBtwItems / 2),
            SizedBox(
              width: 55,
              child: Text(
                'Aki-aki',
                style: Theme.of(context).textTheme.labelMedium!.apply(color: BColors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
        ),
    );
  }
}