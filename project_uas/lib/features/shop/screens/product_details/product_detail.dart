import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/features/shop/screens/cart/cart.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/product_atributtes.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BBottomAddToCart(product: product),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image Slider
            BProductImageSlider(product: product),

            // Image Product Detaill
            Padding(
              padding: const EdgeInsets.only(right: BSize. defaultSpace, left: BSize. defaultSpace, bottom: BSize.defaultSpace),
              child: Column(
                children: [
                  // Produk Detail
                  BProductMetaData(product: product),

                  // Atribut
                  BProductAttributes(product: product),
                  const SizedBox(height: BSize.spaceBtwSections),

                  // check out buton
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.to(const CartScreen()), child: const Text('Checkout'))),
                  const SizedBox(height: BSize.spaceBtwSections),

                  // descripton
                  const BSectionHeading(title: 'Description', showActionButton: false),
                  const SizedBox(height:  BSize.spaceBtwItems),
                  ReadMoreText(
                    product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show More',
                    trimExpandedText: ' Less',
                    moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),

                  const Divider(),
                ]
              ),
            ),
          ]
        ),
      ),
    );
  }
}



