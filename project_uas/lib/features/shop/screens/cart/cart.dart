import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:project_uas/features/shop/screens/checkout/checkout.dart';
import 'package:project_uas/utils/constants/sized.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar (showBackArrow: true,title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall)),
      body: const Padding(
        padding: EdgeInsets. all(BSize.defaultSpace),

        // item in cart
        child: BCartItems(),
      ),
      
      // check out button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(BSize.defaultSpace),
        child: ElevatedButton(onPressed: () => Get.to(() => const CheckoutScreen()), child: const Text('Checkout \$256.0')),
      ),
    );
  }
}

    