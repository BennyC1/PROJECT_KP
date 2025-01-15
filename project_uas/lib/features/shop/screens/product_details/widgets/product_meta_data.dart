import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/images/circular_image.dart';
import 'package:project_uas/common/widgets/texts/brand_title_text_with_verification.dart';
import 'package:project_uas/common/widgets/texts/product_price_text.dart';
import 'package:project_uas/common/widgets/texts/product_title_text.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BProductMetaData extends StatelessWidget {
  const BProductMetaData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final darkMode = BHelperFunctions. isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sole Price
        Row(
          children: [
            /// Sale Tag
            BRoundedContainer (
              radius: BSize.sm,
              backgroundcolor: BColors.secondary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: BSize.sm, vertical: BSize.xs),
              child: Text('25%', style: Theme.of(context).textTheme.labelLarge!.apply(color: BColors.black)),
            ),
          ]
        ),  
        const SizedBox(width: BSize.spaceBtwItems),

        /// Price
        Text("\$258", style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough)),
        const SizedBox(width: BSize. spaceBtwItems),
        const BProductPriceText(price: '175', isLarge: true),
        const SizedBox(height: BSize.spaceBtwItems / 1.5),

        /// Title
        const BProductTitleText(title: 'Green Nike Sports Shirt'),
        const SizedBox(height: BSize. spaceBtwItems / 1.5),

        /// Stock Status
        Row(
          children: [
            const BProductTitleText(title: 'Status'),
            const SizedBox(width: BSize.spaceBtwItems),
            Text( 'In Stock', style: Theme.of (context). textTheme. titleMedium),
          ]
        ),
            
        const SizedBox(height: BSize. spaceBtwItems / 1.5),

        /// Brand
        Row(
          children: [
            BCircularImage (
              image: BImages.shoeIcon,
              width: 32,
              height: 32,
              overlayColor: darkMode ? BColors. white : BColors.black,
            ),
            const BBrandTitleWithVerifiedIcon(title: 'Nike', brandTextSize: TextSizes.medium),
          ],
        ),
      ]
    );
  }
}