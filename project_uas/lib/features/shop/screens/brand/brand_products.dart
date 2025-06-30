import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/brands/brand_card.dart';
import 'package:project_uas/common/widgets/products/sortable/sortable_products.dart';
import 'package:project_uas/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:project_uas/features/shop/controllers/brand_controller.dart';
import 'package:project_uas/features/shop/models/brand_model.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/cloud_helper_functions.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;

    return Scaffold(
      appBar: BAppBar(title: Text(brand.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [
              /// Brand Detail
              BBrandCard (showBorder: true, brand: brand),
              const SizedBox(height: BSize.spaceBtwSections),

              FutureBuilder(
                future: controller.getBrandProducts(brandId: brand.id),
                builder: (context, snapshot) {
                  /// Handle Loader, No Record, OR Error Message
                  const loader = BVerticalProductShimmer ();
                  final widget = BCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                  if (widget != null) return widget;

                  final brandProducts = snapshot.data!;
                  return BSortableProducts(products: brandProducts);
                }
              ),
            ]
          ), 
        )
      )
    );
  }
} 