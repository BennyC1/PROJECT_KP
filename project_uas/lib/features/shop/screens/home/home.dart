import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/primary_header_container.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/search_container.dart';
import 'package:project_uas/common/widgets/images_text_widgets/vertical_image_text.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/screens/brand/all_brands.dart';
import 'package:project_uas/features/shop/screens/brand/brand_products.dart';
import 'package:project_uas/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:project_uas/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:project_uas/features/shop/screens/sub_category/sub_categories.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        BSectionHeading(title: 'Popular Categories', showActionButton: false, textColor: Colors.white, onPressed: () => Get.to(() => const BrandProducts())),
                        const SizedBox(height: BSize.spaceBtwItems),

                        //Categories
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              return BVerticalImageText(image: BImages.shoeIcon, title: 'Aki', onTap: ()=> Get.to(() => const SubCategoriesScreen()),);
                            },
                          ),
                        )
 
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
                  // slide promo 3
                  const BPromoSlider(banners: [BImages.promoBanner1, BImages.banner, BImages.promoBanner3]),
                  const SizedBox(height: BSize.spaceBtwSections),

                  BSectionHeading(title: 'Popular Produtcs', onPressed: () => Get.to(() => const AllBrandsScreen())),
                  const SizedBox(height: BSize.spaceBtwItems),

                  // isi produk
                  BGridLayout(itemCount: 6, itemBuilder: (_, index) => const BProductCardVertical())
                ]
              )
            ),
          ]
        ),
      ),
    );
  }
}



