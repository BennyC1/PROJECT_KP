import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/brands/brand_card_show_case.dart';
import 'package:project_uas/common/widgets/shimmer/boxes_shimmer.dart';
import 'package:project_uas/common/widgets/shimmer/list_tile_shimmer.dart';
import 'package:project_uas/features/shop/controllers/brand_controller.dart';
import 'package:project_uas/features/shop/models/category_model.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/cloud_helper_functions.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({
    super.key,
    required this.category,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return FutureBuilder(
      future: controller.getBrandsForCategory(category.id),
      builder: (context, snapshot) {
        /// Handle Loader, No Record, OR Error Message
        const loader = Column (
        children: [
            BListTileShimmer(),
            SizedBox(height: BSize.spaceBtwItems),
            BBoxesShimmer(),
            SizedBox(height: BSize.spaceBtwItems)
          ]
        );

        // Helper Function : Handle Loader, No Record, OR Error Message
        final widget = BCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
        if (widget != null) return widget;

        // Record Found
        final brands = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: brands.length,
          itemBuilder: (_, index) {
            final brand = brands[index];
            return FutureBuilder(
              future: controller.getBrandProducts(brandId: brand.id, limit: 3),
              builder: (context, snapshot) {

                final widget = BCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                if (widget != null) return widget;

                // Record Found
                final products = snapshot.data!;

                return BBrandShowcase(brand: brand, images: products.map((e) => e.thumbnail).toList());
              }
            );
          }
        );
      }
    );
  }
}