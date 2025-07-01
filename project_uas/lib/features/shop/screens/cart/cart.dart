import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/features/shop/controllers/product/cart_controller.dart';
import 'package:project_uas/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:project_uas/features/shop/screens/checkout/checkout.dart';
import 'package:project_uas/navigation_menu.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/loaders/animation_loader.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;

    return Scaffold(
      appBar: BAppBar(
        showBackArrow: true,
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Obx(() {
        // Nothing Found Widget
        final emptyWidget = BAnimationLoaderWidget(
          text: 'Whoops! Cart is EMPTY.',
          animation: BImages.cartAnimation,
          showAction: true,
          actionText: 'Let\'s fill it',
          onActionPressed: () => Get.off(() => const NavigationMenu()),
        );

        if (controller.cartItems.isEmpty) {
          return emptyWidget;
        } else {
          return const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(BSize.defaultSpace),

              /// -- Items in Cart
              child: BCartItems(),
            ),
          );
        }
      }),
      bottomNavigationBar: Obx(() => controller.cartItems.isEmpty
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(BSize.defaultSpace),
              child: ElevatedButton(
                onPressed: () => Get.to(() => const CheckoutScreen()),
                child: Obx(() => Text('Checkout \Rp ${controller.totalCartPrice.value}')),
              ),
            )
          ), 
    );
  }
}
    