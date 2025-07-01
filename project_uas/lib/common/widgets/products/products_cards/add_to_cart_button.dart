
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/shop/controllers/product/cart_controller.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/features/shop/screens/product_details/product_detail.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/enums.dart';

class ProductCardAddToCartButton extends StatelessWidget {
  const ProductCardAddToCartButton({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return InkWell(
      onTap: () {
        // If the product have variations then show the product Details for variation selection.
        // Else add product to the cart.

        if (product.productType == ProductType.single.toString()) {
        final cartItem = cartController.convertToCartItem(product, 1);
        cartController.addOneToCart(cartItem); 
      } else {
        Get.to(() => ProductDetailScreen(product: product));
        }
      },
      child: Obx (() {
        final productQuantityInCart = cartController.getProductQuantityInCart(product.id);
        return Container(
        decoration: BoxDecoration(
          color: productQuantityInCart > 0 ? BColors.primary : BColors.dark,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(BSize.cardRadiusMd),
            bottomRight: Radius.circular(BSize.productImageRadius),
          ),
        ),
        child: SizedBox(
          width: BSize.iconLg * 1.2,
          height: BSize.iconLg * 1.2,
          child: Center(
            child: productQuantityInCart > 0
                ? Text(productQuantityInCart.toString(), style: Theme.of(context). textTheme.bodyLarge!.apply(color: BColors.white))
                : const Icon(Iconsax.add, color: BColors.white),
          ),
        ),
        );
      }),
    );
  }
}