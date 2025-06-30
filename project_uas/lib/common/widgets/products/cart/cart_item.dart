import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/common/widgets/texts/brand_title_text_with_verification.dart';
import 'package:project_uas/common/widgets/texts/product_title_text.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BCartItem extends StatelessWidget {
  const BCartItem({
    super.key,
  });

  @override
  Widget build (BuildContext context) {
  return Row(
      children: [
        // Image
        BRoundedImage (
          imageUrl: BImages.amaronns40zl,
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(BSize.sm),
          backgroundColor: BHelperFunctions.isDarkMode(context) ? BColors.darkerGrey : BColors.light,
        ),
        const SizedBox(width: BSize.spaceBtwItems),

        // titile price size
        Expanded (
          child: Column (
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BBrandTitleWithVerifiedIcon(title: 'Aki Mobil'),
              const Flexible(child: BProductTitleText(title: 'Amaron NS40ZL', maxLines: 1)),
              /// Attributes
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Color ', style: Theme.of(context).textTheme.bodySmall),
                    TextSpan(text: 'Green ', style: Theme.of(context).textTheme.bodyLarge),
                    TextSpan(text: 'Jenis ', style: Theme.of(context).textTheme.bodySmall),
                    TextSpan(text: 'Aki Mobil ', style: Theme.of(context).textTheme.bodyLarge),
                  ]
                )
              )
            ]
          )
        )
      ]
    );
  }
}

