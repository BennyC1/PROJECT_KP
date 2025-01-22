import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/common/widgets/products/products_cards/product_card_horizontal.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/screens/brand/brand_products.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BAppBar(title: Text('Sports'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [
              /// Banner
              const BRoundedImage(width: double.infinity, imageUrl: BImages.banner1, applyImageRadius: true),
              const SizedBox(height: BSize.spaceBtwSections),
              
              /// Sub-Categories
              Column(
                children: [
                  /// Heading
                  BSectionHeading(title: 'Aki Mobil', onPressed: () => Get.to(() => const BrandProducts())),
                  const SizedBox(height: BSize. spaceBtwItems / 2),

                  SizedBox(
                    height: 120,
                    child: ListView. separated(
                    itemCount: 1,
                    scrollDirection: Axis. horizontal,
                    separatorBuilder: (context, index) => const SizedBox(width: BSize.spaceBtwItems),
                    itemBuilder: (context, index) => const BProductCardHorizontal(),
                    ),
                  ),
                ]
              )
            ]
          )
        )
      )
    );
  }
}
