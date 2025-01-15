import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/texts/brand_title_text.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BBrandTitleWithVerifiedIcon extends StatelessWidget {
  const BBrandTitleWithVerifiedIcon({
    super. key,
    this. textColor,
    this.maxLines = 1,
    required this. title,
    this.iconColor = BColors.primary,
    this.textAlign = TextAlign. center,
    this.brandTextSize = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: BBrandTitleText(
            title: title,
            color: textColor,
            maxLines: maxLines,
            textAlign: textAlign,
            brandTextSize: brandTextSize,
          ),
        ),
        const SizedBox(width: BSize.xs),
        Icon (Iconsax.verify5, color: iconColor, size: BSize.iconXs),
      ]
    );
  }
}