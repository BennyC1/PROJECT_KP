import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/shop/controllers/product/cart_controller.dart';
import 'package:project_uas/features/shop/screens/cart/cart.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BCartCounterIcon extends StatelessWidget {
  const BCartCounterIcon({
    super.key, 
    this.iconColor, 
  });

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    final controller = Get.put(CartController());

    return Stack (
      children: [
        IconButton (onPressed:  () => Get.to(() => const CartScreen()), 
        icon: Icon(Iconsax.shopping_bag, color: dark ? BColors.white : BColors.dark)),
        Positioned (
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: BColors.black,
              borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Obx(
                   ()=> Text(
                    controller.noOfCartItems.value.toString(), 
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                      color: BColors.white, fontSizeFactor: 0.8)),
                )),
              ),
        ),
      ]  
    );
  }
}