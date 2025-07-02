import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/common/widgets/products/cart/add_remove_button.dart';
import 'package:project_uas/common/widgets/products/cart/cart_item.dart';
import 'package:project_uas/common/widgets/texts/product_price_text.dart';
import 'package:project_uas/features/shop/controllers/product/cart_controller.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BCartItems extends StatelessWidget {
  const BCartItems({
    super.key, 
    this.showAddRemoveButtons = true,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    
    return Obx(() {
      if (!showAddRemoveButtons) {
        // Mode readonly, pakai Column
        return Column(
          children: List.generate(cartController.cartItems.length, (index) {
            final item = cartController.cartItems[index];
            return Column(
              children: [
                BCartItem(cartItem: item),
                const SizedBox(height: BSize.spaceBtwSections),
              ],
            );
          }),
        );
      } else {
        // Mode interaktif, pakai ListView
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartController.cartItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: BSize.spaceBtwSections),
          itemBuilder: (_, index) => Obx(() {
            final item = cartController.cartItems[index];
            return Column(
              children: [
                BCartItem(cartItem: item),
                if (showAddRemoveButtons) const SizedBox(height: BSize.spaceBtwItems),
                if (showAddRemoveButtons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 70),
                          BProductQuantityWithAddRemoveButton(
                            quantity: item.quantity,
                            add: () => cartController.addOneToCart(item),
                            remove: () => cartController.removeOneFromCart(item),
                          ),
                        ],
                      ),
                      BProductPriceText(
                        currencySign: '',
                        price: NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(item.price * item.quantity),
                      ),
                    ],
                  ),
              ],
            );
          }),
        );
      }
    });
  }
}
    