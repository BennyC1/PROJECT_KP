import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/common/widgets/products/products_cards/product_card_horizontal.dart';
import 'package:project_uas/common/widgets/shimmer/horizontal_product_shimmer.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/controllers/category_controller.dart';
import 'package:project_uas/features/shop/models/category_model.dart';
import 'package:project_uas/features/shop/screens/all_products/all_products.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/cloud_helper_functions.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category,});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return Scaffold(
      appBar: BAppBar(title: Text(category.name), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [
              /// Banner
              const BRoundedImage(width: double.infinity, imageUrl: BImages.banner1, applyImageRadius: true),
              const SizedBox(height: BSize.spaceBtwSections),
              
              /// Sub-Categories
              FutureBuilder(
                future: controller.getSubCategories(category.id),
                builder: (context, snapshot) {
                  /// Handle Loader, No Record, OR Error Message
                  const loader = BHorizontalProductShimmer();
                  final widget = BCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                  if (widget != null) return widget;

                  /// Record found.
                  final subCategories = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: subCategories.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {

                      final subCategory = subCategories[index];
                      return FutureBuilder(
                        future: controller.getCategoryProducts(categoryId: subCategory.id),
                        builder: (context, snapshot) {
                          /// Handle Loader, No Record, OR Error Message          
                          final widget = BCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                          if (widget != null) return widget;

                          /// Congratulations Record found.
                          final products = snapshot.data!;

                          return Column(
                            children: [
                              /// Heading
                              BSectionHeading(
                                title: subCategory.name,
                                onPressed: () => Get.to(
                                  () => AllProducts(
                                    title: subCategory.name,
                                    futureMethod: controller.getCategoryProducts(categoryId: subCategory.id, limit: -1),
                                  ),
                                ),
                              ),
                              const SizedBox(height: BSize.spaceBtwItems / 2),
              
                              SizedBox(
                                height: 120,
                                child: ListView. separated(
                                  itemCount: products.length,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) => const SizedBox(width: BSize.spaceBtwItems),
                                  itemBuilder: (context, index) => BProductCardHorizontal(product: products[index]),
                                ),
                              ),
                              const SizedBox(height: BSize. spaceBtwItems),
                            ]
                          );
                        }                                                 
                      );
                    }
                  );
                }
              )
            ]
          )
        )
      )
    );
  }
}
