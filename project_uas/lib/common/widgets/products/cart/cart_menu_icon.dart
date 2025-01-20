import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/shop/screens/cart/cart.dart';
import 'package:project_uas/utils/constants/colors.dart';

class BCartCounterIcon extends StatelessWidget {
  const BCartCounterIcon({
    super.key, this.iconColor, required this.onPressed,
  });

  final Color? iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack (
      children: [
        IconButton (onPressed:  () => Get.to(() => const CartScreen()), icon: const Icon(Iconsax.shopping_bag, color: BColors.white)),
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
                child: Text('2', style: Theme.of(context).textTheme.labelLarge!.apply(color: BColors.white, fontSizeFactor: 0.8))),
              ),
        ),
      ]  
    );
  }
}