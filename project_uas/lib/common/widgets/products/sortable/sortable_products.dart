import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BSortableProducts extends StatelessWidget {
  const BSortableProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column (
      children: [
        /// Dropdown
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          onChanged: (value) {},
          items: ['Name', 'Higher Price', 'Lower Price', 'Sale', 'Newest', 'Popularity']
            .map ( (option) => DropdownMenuItem(value: option, child: Text(option))).
            toList()
        ),
        const SizedBox(height: BSize.spaceBtwSections),

        /// Products
        BGridLayout (itemCount: 1, itemBuilder: ( _, index) => const BProductCardVertical()),
      ]
    );
  }
}

