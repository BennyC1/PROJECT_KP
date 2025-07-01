
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/icons/circular_icon.dart';
import 'package:project_uas/features/shop/controllers/product/cart_controller.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BBottomAddToCart extends StatelessWidget {
  const BBottomAddToCart({
    super.key, 
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    controller.updateAlreadyAddedProductCount(product);
    final dark = BHelperFunctions. isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: BSize.defaultSpace, vertical: BSize.defaultSpace / 2),
      decoration: BoxDecoration(
        color: dark ? BColors.darkerGrey : BColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(BSize.cardRadiusLg),
          topRight: Radius.circular(BSize.cardRadiusLg)
        )
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row (
              children: [
                BCircularIcon(
                  icon: Iconsax.minus,
                  backgroundcolor: BColors.darkGrey,
                  width: 40,
                  height: 40,
                  color: BColors.white,
                  onPressed: controller.productQuantityInCart.value < 1  ? null  : () => controller.productQuantityInCart.value -= 1,
                ),
                const SizedBox(width: BSize.spaceBtwItems),
                Text(controller.productQuantityInCart.value.toString(), style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: BSize.spaceBtwItems),
                BCircularIcon(
                  icon: Iconsax.add,
                  backgroundcolor: BColors.black,
                  width: 40,
                  height: 40,
                  color: BColors.white,
                  onPressed: () => controller.productQuantityInCart.value += 1,
                ),
              ]
            ),  
            ElevatedButton (
              onPressed: controller.productQuantityInCart.value < 1  ? null  : () => controller.addToCart(product),
              style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(BSize.md),
              backgroundColor: BColors.black,
              side: const BorderSide(color: BColors.black),
            ),
              child: const Text('Add to Cart'),
            )
          ]
        )
      )
    );
  }
}
