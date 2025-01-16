import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/custom_shape/curved_edges/curved_edges_widget.dart';
import 'package:project_uas/common/widgets/icons/circular_icon.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/product_atributtes.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:project_uas/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image Slider
            BProductImageSlider(),

            // Image Product Detaill
            Padding(
              padding: const EdgeInsets.only(right: BSize. defaultSpace, left: BSize. defaultSpace, bottom: BSize.defaultSpace),
              child: Column(
                children: [
                  /// Rating & Share Button
                  BRatingAndShare(),

                  // Produk Detail
                  BProductMetaData(),

                  // Atribut
                  BProductAttributes(),

                  // buton

                  // descripton

                  // review
                ]
              ),
            ),
          ]
        ),
      ),
    );
  }
}



