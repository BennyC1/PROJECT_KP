import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/products/cart/add_remove_button.dart';
import 'package:project_uas/common/widgets/products/cart/cart_item.dart';
import 'package:project_uas/common/widgets/texts/product_price_text.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BCartItems extends StatelessWidget {
  const BCartItems({
    super.key, 
    this.showAddRemoveButtons = true,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    return ListView. separated(
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (_, __) => const SizedBox(height: BSize.spaceBtwSections),
      itemBuilder: (_, index) => Column(
        children: [
          const BCartItem(),
          if(showAddRemoveButtons) const SizedBox(height: BSize. spaceBtwItems),

          // add remove button row + total price
          if(showAddRemoveButtons) 
            const Row(
              mainAxisAlignment: MainAxisAlignment. spaceBetween,
              children: [
                Row(
                  children: [
                    /// Extra Space
                    SizedBox(width: 70),
            
                    /// Add Remove Buttons
                    BProductQuantityWithAddRemoveButton(),
                  ]
                ), 
             
              // Product total Price          
              BProductPriceText(price: '256'),
            ]
          )                      
        ]
      ),
    );
  }
}
    