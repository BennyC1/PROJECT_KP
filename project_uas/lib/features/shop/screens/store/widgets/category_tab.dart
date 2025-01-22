import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/screens/all_products/all_products.dart';
import 'package:project_uas/utils/constants/image_string.dart';

import '../../../../../common/widgets/brands/brand_card_show_case.dart';
import '../../../../../utils/constants/sized.dart';


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
              const BBrandShowcase(images: [BImages.amaronns40zl, BImages.amaronns40zl, BImages.amaronns40zl]),
              const SizedBox(height: BSize.spaceBtwItems),
        
              // Product
              BSectionHeading(title: 'You might like', onPressed: () => Get.to(() => const AllProducts())),
              const SizedBox(height: BSize.spaceBtwItems),
        
              BGridLayout(itemCount: 1, itemBuilder: (_, index) => const BProductCardVertical()),
              const SizedBox(height: BSize.spaceBtwSections),
            ],
          ),
        ),
      ]
    );
  }
}