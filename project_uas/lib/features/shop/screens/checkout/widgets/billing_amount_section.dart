import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BBillingAmountSection extends StatelessWidget {
  const BBillingAmountSection({
   super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// SubTotal
        Row (
          mainAxisAlignment: MainAxisAlignment. spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context) . textTheme.bodyMedium),
            Text('\Rp 1.250.000', style: Theme.of(context). textTheme.bodyMedium),
          ]      
        ),
        const SizedBox(height: BSize.spaceBtwItems / 2),

        /// Shipping Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Discount', style: Theme.of(context).textTheme.bodyMedium),
            Text("\Rp 312.500", style: Theme.of(context).textTheme.labelLarge),
          ]
        ),
        const SizedBox (height: BSize.spaceBtwItems / 2),

        /// Tax Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text('\Rp 24.000', style: Theme.of(context).textTheme.labelLarge),
          ]
        ),
        const SizedBox(height: BSize.spaceBtwItems / 2),

        /// Order Totol
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.bodyMedium),
            Text('\Rp 977.500', style: Theme.of(context).textTheme.titleMedium),
          ]
        ),
      ]
    );
  }
}
          


