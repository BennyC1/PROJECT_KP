import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/styles/shadows.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/icons/circular_icon.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/common/widgets/texts/brand_title_text_with_verification.dart';
import 'package:project_uas/common/widgets/texts/product_price_text.dart';
import 'package:project_uas/common/widgets/texts/product_title_text.dart';
import 'package:project_uas/features/shop/screens/product_details/product_detail.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BProductCardVertical extends StatelessWidget {
  const BProductCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () {},
      child: Container (
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [BShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(BSize.productImageRadius),
          color: dark ? BColors.darkerGrey : BColors.white,
        ),
      
        child: Column(
          children: [
            /// Thumbnoil, WishList Button, Discount Tag
            BRoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(BSize.sm),
              backgroundcolor: dark ? BColors.dark : BColors.light,
              child: Stack(
                children: [
                  // Thumbnail - Image
                  BRoundedImage(imageUrl: BImages.amaronns40zl, applyImageRadius: true, onPressed: () => Get.to(() => const ProductDetailScreen())),
      
                  /// Sale Tag
                  Positioned (
                    top: 12,
                    child: BRoundedContainer (
                      radius: BSize.sm,
                      backgroundcolor: BColors.secondary.withOpacity(0.8),
                      padding: const EdgeInsets. symmetric(horizontal: BSize.sm, vertical: BSize.xs),
                      child: Text('25%', style: Theme.of(context).textTheme.labelLarge!.apply(color:BColors.black)),
                    ),
                  ), 
      
                  /// Favourite Icon Button
                  const Positioned(
                    top: 0,
                    right: 0.1,
                    child: BCircularIcon(icon: Iconsax. heart5, color: Colors.red),        
                  ),
                ]
              ),
            ),
            const SizedBox(height: BSize.spaceBtwItems / 2),
      
            // Detail
            const Padding(
              padding: EdgeInsets.only(left: BSize.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BProductTitleText(title:'Amaron NS40ZL', smallsize: true),
                  SizedBox(height: BSize.spaceBtwItems / 2),
                  BBrandTitleWithVerifiedIcon(title: 'Aki Mobil'),
                ]
              ),
            ),
            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Price
                  const BProductPriceText(price: '1.250.000'),

                  Container (
                    decoration: const BoxDecoration(
                      color: BColors. dark,
                      borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(BSize.cardRadiusMd),
                      bottomRight: Radius.circular(BSize.productImageRadius),
                      ),
                    ),
                    child: const SizedBox(
                      width: BSize.iconLg * 1.2,
                      height: BSize.iconLg * 1.2,
                      child: Center(child: Icon(Iconsax.add, color: BColors.white)),
                    ),
                  ),
                ]
            )
          ]
        ),
      ),
    );
  }
}