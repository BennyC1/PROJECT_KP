import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/icons/circular_icon.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/common/widgets/texts/brand_title_text_with_verification.dart';
import 'package:project_uas/common/widgets/texts/product_price_text.dart';
import 'package:project_uas/common/widgets/texts/product_title_text.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BProductCardHorizontal extends StatelessWidget {
  const BProductCardHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return Container(
      width: 310,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BSize.productImageRadius),
        color: dark ? BColors. darkerGrey : BColors.softGrey,
      ),
      child: Row (
        children: [
          /// Thumbnail
          BRoundedContainer (
            height: 120,
            padding: const EdgeInsets.all(BSize.sm),
            backgroundcolor: dark ? BColors.dark : BColors.light,
            child: const Stack (
              children: [
                /// -- Thumbnail Image
                SizedBox(
                  height: 120,
                  width: 120,
                  child: BRoundedImage(imageUrl: BImages.productImage1, applyImageRadius: true)
                ),

                /// Favourite Icon Button
                Positioned(
                  top: 0,
                  right: 0.1,
                  child: BCircularIcon(icon: Iconsax. heart5, color: Colors.red),        
                ),
              ]
            )
          ),   

          // detail
          SizedBox(
            width: 172,
            child: Padding(
              padding: const EdgeInsets. only(top: BSize.sm, left: BSize.sm),
              child: Column (
                children: [
                  const Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BProductTitleText(title: 'Green Nike Half Sleeves Shirt', smallsize: true),
                      SizedBox(height: BSize. spaceBtwItems / 2),
                      BBrandTitleWithVerifiedIcon(title: 'Nike'),
                    ],
                  ),

                  const Spacer (),

                  Row(
                    mainAxisAlignment: MainAxisAlignment. spaceBetween,
                    children: [
                      /// Pricing
                      const Flexible(child: BProductPriceText(price: '256.0')),

                      /// Add to cart
                      Container (
                        decoration: const BoxDecoration(
                          color: BColors. dark,
                          borderRadius: BorderRadius. only(
                            topLeft: Radius.circular(BSize.cardRadiusMd),
                            bottomRight: Radius.circular (BSize.productImageRadius),
                          ),
                        ),
                        child: const SizedBox (
                          width: BSize.iconLg * 1.2,
                          height: BSize.iconLg * 1.2,
                          child: Center(child: Icon(Iconsax.add, color: BColors.white)),
                        ),
                      ), 
                    ],               
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}
        
    
