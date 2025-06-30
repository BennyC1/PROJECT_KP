import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:project_uas/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/controllers/category_controller.dart';
import 'package:project_uas/features/shop/models/category_model.dart';
import 'package:project_uas/features/shop/screens/all_products/all_products.dart';
import 'package:project_uas/features/shop/screens/store/widgets/category_brands.dart';
import 'package:project_uas/utils/helpers/cloud_helper_functions.dart';

import '../../../../../utils/constants/sized.dart';


class BCategoryTab extends StatelessWidget {
  const BCategoryTab({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding (
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [
              //  Brands
              CategoryBrands(category: category),
              const SizedBox(height: BSize.spaceBtwItems),
        
              // Product
              FutureBuilder(
                future: controller.getCategoryProducts(categoryId: category.id),
                builder: (context, snapshot) {

                  // Helper Function : Handle Loader, No Record, OR Error Message
                  final response = BCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: const BVerticalProductShimmer());
                  if (response != null) return response;

                  // Record Found
                  final products = snapshot.data!;

                  return Column(
                    children: [
                      BSectionHeading(
                        title: 'You might like', 
                        onPressed: () => Get.to(AllProducts(
                          title: category.name,
                          futureMethod: controller.getCategoryProducts(categoryId: category.id, limit: -1),
                        )),
                      ),
                      const SizedBox(height: BSize.spaceBtwItems), 
                      BGridLayout(itemCount: products.length, itemBuilder: (_, index) => BProductCardVertical(product: products[index])),
                    ],
                  );
                }
              ),             
            ],
          ),
        ),
      ]
    );
  }
}
