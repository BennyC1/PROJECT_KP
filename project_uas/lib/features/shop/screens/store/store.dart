import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/appbar/tabbar.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/search_container.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/brands/brand_card.dart';
import 'package:project_uas/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/screens/brand/all_brands.dart';
import 'package:project_uas/features/shop/screens/store/widgets/category_tab.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: BAppBar(
          title: Text('Store',style:Theme.of(context).textTheme.headlineMedium),
          actions: [
            BCartCounterIcon(onPressed: (){}),
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
      
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(BSize.defaultSpace),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: BSize.spaceBtwItems),
                    const BSearchContainer(text: 'Search in Store', showBorder: true, showBackground: false, padding: EdgeInsets.zero,),
                    const SizedBox(height: BSize.spaceBtwSections),
      
                    BSectionHeading(title: 'Featured Brands', onPressed: () => Get.to(() => const AllBrandsScreen())),
                    const SizedBox(height: BSize.spaceBtwItems / 1.5),
      
                    BGridLayout(itemCount: 3, mainAxisExtent: 80, itemBuilder: (_, index) {
                      return const BBrandCard(showBorder: true);
                    })
                  ]
                ),
              ),
              bottom: const BTabBar(
                tabs: [
                  Tab(child: Text('Aki Motor')),
                  Tab(child: Text('Aki Mobil')),
                  Tab(child: Text('Aki VRla')),
                  Tab(child: Text('Jumper Aki')),
                  Tab(child: Text('Jumper Cas Aki')),
                ]
              )
            ),
          ];
        },

        body: const TabBarView(
          children: [
            BCategoryTab(),
            BCategoryTab(),
            BCategoryTab(),
            BCategoryTab(),
            BCategoryTab(),
          ],
        ),
      ),
    ),
    );
  }
}





