import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/brands/brand_card.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/screens/brand/brand_products.dart';
import 'package:project_uas/utils/constants/sized.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BAppBar(title: Text('Brand' ), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [
              /// Heading
              const BSectionHeading(title: 'Brands', showActionButton: false),
              const SizedBox (height: BSize.spaceBtwItems),

              /// - Brands
              BGridLayout(
                itemCount: 3,
                mainAxisExtent: 80,
                itemBuilder: (context, index) => BBrandCard(
                  showBorder: true,
                  onTap: () => Get.to(() => const BrandProducts()), 
                ),
              ),
            ] 
          )
        )
      )
    );
  }
}
