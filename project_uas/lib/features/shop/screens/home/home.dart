import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/primary_header_container.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/search_container.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:project_uas/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/controllers/product/product_controller.dart';
import 'package:project_uas/features/shop/models/brand_model.dart';
import 'package:project_uas/features/shop/screens/all_products/all_products.dart';
import 'package:project_uas/features/shop/screens/brand/brand_products.dart';
import 'package:project_uas/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:project_uas/features/shop/screens/home/widgets/home_categories.dart';
import 'package:project_uas/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:project_uas/utils/constants/sized.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BPrimaryHeaderContainer(
              child: Column (
                children: [
                  // home
                  const BHomeAppBar(),
                  const SizedBox(height: BSize.spaceBtwSections),

                  //search
                  const BSearchContainer(text: 'Search in Store'),
                  const SizedBox(height: BSize.spaceBtwSections),

                  Padding(
                    padding: const EdgeInsets.only(left: BSize.defaultSpace),
                    child: Column(
                      children: [
                        //Heading
                        BSectionHeading(title: 'Popular Categories', showActionButton: false, textColor: Colors.white, onPressed: () => Get.to(() => BrandProducts(brand: BrandModel.empty()))),
                        const SizedBox(height: BSize.spaceBtwItems),

                        //Categories
                        const BHomeCategories(),
                      ],
                    ) 
                  ),
                  const SizedBox(height: BSize.spaceBtwSections),
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(BSize.defaultSpace),
              child: Column(
                children: [
                  // slide promo 
                  const BPromoSlider(),
                  const SizedBox(height: BSize.spaceBtwSections),

                  BSectionHeading(
                    title: 'Popular Products',
                      onPressed: () => Get.to(
                        () => AllProducts(
                        title: 'Popular Products',
                        futureMethod: controller.fetchAllFeaturedProducts(),
                      ), 
                    ),
                  ), 

                  const SizedBox(height: BSize.spaceBtwItems),

                  // isi produk
                  Obx(() {
                    if (controller.isLoading.value) return const BVerticalProductShimmer();

                    if (controller.featuredProducts.isEmpty) {
                      return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium));
                    }

                    return BGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_, index) => BProductCardVertical(product: controller.featuredProducts[index]),
                    );
                  }) 
                ]
              )
            ),
          ]
        ),
      ),
    );
  }
}



