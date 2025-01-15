import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/utils/constants/image_string.dart';

import '../../../../../../common/widgets/brands/brand_card_show_case.dart';
import '../../../../../../utils/constants/sized.dart';


class BCategoryTab extends StatelessWidget {
  const BCategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding (
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [
              //  Brands
              const BBrandShowcase(images: [BImages.productImage3, BImages.productImage3, BImages.productImage3]),
              const BBrandShowcase(images: [BImages.productImage3, BImages.productImage3, BImages.productImage3]),
              const SizedBox(height: BSize.spaceBtwItems),
        
              // Produc
              BSectionHeading(title: 'You might like', onPressed: () {}),
              const SizedBox(height: BSize.spaceBtwItems),
        
              BGridLayout(itemCount: 4, itemBuilder: (_, index) => const BProductCardVertical()),
              const SizedBox(height: BSize.spaceBtwSections),
            ],
          ),
        ),
      ]
    );
  }
}