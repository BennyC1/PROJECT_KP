import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/images/circular_image.dart';
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
    this.isNetworkImage = true,
    this.onTap,
  });  

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final bool isNetworkImage;
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
            BCircularImage(
              image: image,
              fit: BoxFit.fitWidth,
              padding: BSize.sm * 1.4,
              isNetworkImage: isNetworkImage,
              backgroundColor: backgroundColor,
              overlayColor: dark ? BColors.light : BColors.dark,
            ),
            const SizedBox(height: BSize.spaceBtwItems / 2),
            SizedBox(
              width: 54,
              child: Text(
                title,
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