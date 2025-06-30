import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/custom_shape/curved_edges/curved_edges_widget.dart';
import 'package:project_uas/common/widgets/icons/circular_icon.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/features/shop/controllers/product/images_controller.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BProductImageSlider extends StatelessWidget {
  const BProductImageSlider({
    super.key, required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    final controller = Get.put(ImagesController());
    final images = controller.getAllProductImages(product);

    return BCurvedEdgesWidget(
      child: Container (
        color: dark ? BColors.darkerGrey : BColors.light,
        child: Stack(
          children: [
            /// Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all (BSize.productImageRadius * 2),
                child: Center(child: Obx(() {
                  final image = controller.selectedProductImage.value;
                  return GestureDetector(
                    onTap: () => controller.showEnlargedImage(image),
                    child: CachedNetworkImage(
                      imageUrl: image, 
                      progressIndicatorBuilder: (_, __, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress, color: BColors.primary),  
                    ),
                  );
                })),
              ),
            ),
    
            /// Image Slider
            Positioned (
              right: 0,
              bottom: 30,
              left: BSize.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView. separated(
                  itemCount: images.length,
                  shrinkWrap: true,
                  scrollDirection: Axis. horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox (width: BSize.spaceBtwItems),
                  itemBuilder: (_, index) => Obx(
                    () {
                      final imageSelected = controller.selectedProductImage.value == images[index];
                      return BRoundedImage(
                        width: 80,
                        isNetworkImage: true,
                        imageUrl: images[index],
                        padding: const EdgeInsets.all(BSize.sm),
                        backgroundColor: dark ? BColors.dark : BColors.white,
                        onPressed: () => controller.selectedProductImage.value = images[index],
                        border: Border.all(color: imageSelected ? BColors.primary : Colors.transparent),
                      );
                    } 
                  ),
                ), 
              ),
            ),

            // Appbar Icons
            const BAppBar (
              showBackArrow: true,
              actions: [BCircularIcon(icon: Iconsax .heart5, color: Colors.red)],
            ),
          ],
        ),
      ),
    );
  }
}