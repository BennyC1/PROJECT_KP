import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        itemCount: cartController.cartItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: BSize.spaceBtwSections),
        itemBuilder: (_, index) => Obx(() {
          final item = cartController.cartItems[index];
          return Column(
            children: [
              BCartItem(cartItem : item),
              if(showAddRemoveButtons) const SizedBox(height: BSize. spaceBtwItems),
                
              // add remove button row + total price
              if(showAddRemoveButtons) 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        /// Extra Space
                        const SizedBox(width: 70),
                
                        /// Add Remove Buttons
                        BProductQuantityWithAddRemoveButton(
                          quantity: item.quantity,
                          add: () => cartController.addOneToCart(item),
                          remove: () => cartController.removeOneFromCart(item),                     
                        ),
                      ]
                    ), 
                 
                  // Product total Price          
                  BProductPriceText(price: (item.price * item.quantity).toStringAsFixed(1)),
                ]
              )                      
            ]
          );
        }
           
        ),
      ),
    );
  }
}
    