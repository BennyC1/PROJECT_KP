import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/brands/brand_card.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/shimmer/brands_shimmer.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/controllers/brand_controller.dart';
import 'package:project_uas/features/shop/screens/brand/brand_products.dart';
import 'package:project_uas/utils/constants/sized.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;

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
              Obx(
                () {
                  if(brandController.isLoading.value) return const BBrandsShimmer();

                  if (brandController.allBrands.isEmpty) {
                    return Center (
                      child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
                  }

                  return BGridLayout(
                    itemCount: brandController.allBrands.length, 
                    mainAxisExtent: 80, 
                    itemBuilder: (_, index) {
                      final brand = brandController.allBrands[index];

                      return BBrandCard(
                        showBorder: true, 
                        brand: brand,
                        onTap: () => Get.to(() => BrandProducts(brand: brand)));
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
