import 'package:flutter/material.dart';
import 'package:project_uas/features/shop/controllers/product/cart_controller.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/pricing_calculator.dart';

class BBillingAmountSection extends StatelessWidget {
  const BBillingAmountSection({
   super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final discount = cartController.getTotalDiscount();
    final subTotal = cartController.totalCartPrice.value;
    final tax = BPricingCalculator.calculateTax(subTotal, "Indonesia");
    final total = subTotal + tax - discount;

    return Column(
      children: [
        /// SubTotal
        Row (
          mainAxisAlignment: MainAxisAlignment. spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context) . textTheme.bodyMedium),
            Text('Rp $subTotal', style: Theme.of(context). textTheme.bodyMedium),
          ]      
        ),
        const SizedBox(height: BSize.spaceBtwItems / 2),

        /// Tax Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text('Rp ${tax.toStringAsFixed(0)}', style: Theme.of(context).textTheme.labelLarge),
          ]
        ),

        const SizedBox(height: BSize.spaceBtwItems / 2),
        /// Promo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Promo', style: Theme.of(context).textTheme.bodyMedium),
            Text("Rp ${discount.toStringAsFixed(0)}", style: Theme.of(context).textTheme.labelLarge),
          ]
        ),
        const SizedBox (height: BSize.spaceBtwItems / 2),

        /// Order Totol
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.bodyMedium),
            Text('Rp ${total.toStringAsFixed(0)}', style: Theme.of(context).textTheme.titleMedium),
          ]
        ),
      ]
    );
  }
}
          


