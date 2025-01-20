import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/product_atributtes.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:project_uas/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image Slider
            const BProductImageSlider(),

            // Image Product Detaill
            Padding(
              padding: const EdgeInsets.only(right: BSize. defaultSpace, left: BSize. defaultSpace, bottom: BSize.defaultSpace),
              child: Column(
                children: [
                  /// Rating & Share Button
                  const BRatingAndShare(),

                  // Produk Detail
                  const BProductMetaData(),

                  // Atribut
                  const BProductAttributes(),
                  const SizedBox(height: BSize.spaceBtwSections),

                  // check out buton
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Checkout'))),
                  const SizedBox(height: BSize.spaceBtwSections),

                  // descripton
                  const BSectionHeading(title: 'Description', showActionButton: false),
                  const SizedBox(height:  BSize.spaceBtwItems),
                  const ReadMoreText(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sit amet nulla auctor, vesti Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sit amet nulla auctor, vestiLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sit amet nulla auctor, vesti',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show More',
                    trimExpandedText: ' Less',
                    moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),

                  // review 
                  const Divider(),
                  const SizedBox(height: BSize.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BSectionHeading(title: 'Review (199)',),
                      IconButton(icon: const Icon(Iconsax.arrow_right_3, size: 18), onPressed: () => Get.to(() => const ProductReviewsScreen())),
                    ],
                  ),
                  const SizedBox(height: BSize.spaceBtwSections),
                ]
              ),
            ),
          ]
        ),
      ),
    );
  }
}



