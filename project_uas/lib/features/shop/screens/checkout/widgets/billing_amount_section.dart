import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final discount = cartController.getTotalDiscount();
    final subTotal = cartController.getOriginalTotalPrice();
    final tax = BPricingCalculator.calculateTax(subTotal, "Indonesia");
    final total = subTotal + tax - discount;

    return Column(
      children: [
        /// SubTotal
        Row (
          mainAxisAlignment: MainAxisAlignment. spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
            Text(currencyFormatter.format(subTotal), style: Theme.of(context).textTheme.bodyMedium),
          ]      
        ),
        const SizedBox(height: BSize.spaceBtwItems / 2),

        /// Tax Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text(currencyFormatter.format(tax), style: Theme.of(context).textTheme.labelLarge),
          ]
        ),

        const SizedBox(height: BSize.spaceBtwItems / 2),
        /// Promo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Discount', style: Theme.of(context).textTheme.bodyMedium),
            Text(currencyFormatter.format(discount), style: Theme.of(context).textTheme.labelLarge),
          ]
        ),
        const SizedBox (height: BSize.spaceBtwItems / 2),

        /// Order Totol
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.bodyMedium),
            Text(currencyFormatter.format(total), style: Theme.of(context).textTheme.titleMedium),
          ]
        ),
      ]
    );
  }
}
          


