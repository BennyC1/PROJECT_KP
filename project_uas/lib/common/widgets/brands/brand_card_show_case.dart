import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/brands/brand_card.dart';
import 'package:project_uas/common/widgets/shimmer/shimmer.dart';
import 'package:project_uas/features/shop/models/brand_model.dart';
import 'package:project_uas/features/shop/screens/brand/brand_products.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BBrandShowcase extends StatelessWidget {
  const BBrandShowcase({
    super.key, 
    required this.images, 
    required this.brand,
  });

  final BrandModel brand;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to (() => BrandProducts(brand: brand)),
      child: BRoundedContainer (
        showBorder: true,
        borderColor: BColors.darkGrey,
        backgroundcolor: Colors.transparent,
        padding: const EdgeInsets.all(BSize.md),
        margin: const EdgeInsets.only(bottom: BSize.spaceBtwItems),
        child: Column(
          children: [
            /// Brand with Products Count
            BBrandCard(showBorder: false, brand: brand),
            const SizedBox(height: BSize.spaceBtwItems),
      
            /// Brand Top 3 Product Images
            Row(
              children: images.map((image) => brandTopProductImageWidget(image, context)).toList()
            ),
          ],
        ),
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, context) {
    return Expanded (
      child: BRoundedContainer (
        height: 100,
        padding: const EdgeInsets.all(BSize.md),
        margin: const EdgeInsets.only(right: BSize.sm),
        backgroundcolor: BHelperFunctions.isDarkMode(context) ? BColors.darkerGrey : BColors.light,
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: image,
          progressIndicatorBuilder: (context, url, downloadProgress) => const BShimmerEffect(width: 100, height: 100),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}