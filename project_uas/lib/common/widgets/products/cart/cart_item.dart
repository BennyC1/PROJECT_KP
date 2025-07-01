import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/common/widgets/texts/brand_title_text_with_verification.dart';
import 'package:project_uas/common/widgets/texts/product_title_text.dart';
import 'package:project_uas/features/shop/models/cart_item_model.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BCartItem extends StatelessWidget {
  const BCartItem({
    super.key, 
    required this.cartItem,
  });

  final CartItemModel cartItem;

  @override
  Widget build (BuildContext context) {
  return Row(
      children: [
        // Image
        BRoundedImage (
          imageUrl: cartItem.image ?? '',
          width: 60,
          height: 60,
          isNetworkImage: true,
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
              BBrandTitleWithVerifiedIcon(title: cartItem.brandName ?? ''),
              Flexible(child: BProductTitleText(title: cartItem.title, maxLines: 1)),
              /// Attributes
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Product: ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: cartItem.brandName ?? 'No Brand',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ]
          )
        )
      ]
    );
  }
}

