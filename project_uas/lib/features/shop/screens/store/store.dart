import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/appbar/tabbar.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/search_container.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/brands/brand_card.dart';
import 'package:project_uas/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:project_uas/common/widgets/shimmer/brands_shimmer.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/controllers/brand_controller.dart';
import 'package:project_uas/features/shop/controllers/category_controller.dart';
import 'package:project_uas/features/shop/screens/brand/all_brands.dart';
import 'package:project_uas/features/shop/screens/brand/brand_products.dart';
import 'package:project_uas/features/shop/screens/store/widgets/category_tab.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  Future<void> refreshStoreData() async {
    await Future.wait([
      Get.find<BrandController>().getFeaturedBrands(),
      Get.find<CategoryController>().fetchCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final categories = CategoryController.instance.featuredCategories;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: BAppBar(
          title: Text('Store',style:Theme.of(context).textTheme.headlineMedium),
          actions: const [
            BCartCounterIcon(),
          ],
        ),
        body: NestedScrollView(headerSliverBuilder: (_, innerBoxIsScrolled) {
          return [
            SliverAppBar (
              automaticallyImplyLeading: false,
              pinned: true,
              floating: true,
              backgroundColor: BHelperFunctions.isDarkMode(context) ? BColors.black : BColors.white,
              expandedHeight: 440,
      
              flexibleSpace: RefreshIndicator(
                onRefresh: refreshStoreData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(BSize.defaultSpace),
                  child: Column(
                    children: [
                      const SizedBox(height: BSize.spaceBtwItems),
                      const BSearchContainer(text: 'Search in Store', showBorder: true, showBackground: false, padding: EdgeInsets.zero),
                      const SizedBox(height: BSize.spaceBtwSections),

                      BSectionHeading(title: 'Featured Brands', onPressed: () => Get.to(() => const AllBrandsScreen())),
                      const SizedBox(height: BSize.spaceBtwItems / 1.5),

                      Obx(() {
                        if (brandController.isLoading.value) return const BBrandsShimmer();
                        if (brandController.featuredBrands.isEmpty) {
                          return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium));
                        }

                        return BGridLayout(
                          itemCount: brandController.featuredBrands.length,
                          mainAxisExtent: 80,
                          itemBuilder: (_, index) {
                            final brand = brandController.featuredBrands[index];
                            return BBrandCard(
                              showBorder: true,
                              brand: brand,
                              onTap: () => Get.to(() => BrandProducts(brand: brand)),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),

              bottom: BTabBar(tabs: categories.map((category) => Tab(child: Text(category.name))).toList() ),
            ),
          ];
        },
        body: TabBarView(
          children: categories.map((category) => BCategoryTab(category: category)).toList()
        ),
      ),
    ),
    );
  }
}





