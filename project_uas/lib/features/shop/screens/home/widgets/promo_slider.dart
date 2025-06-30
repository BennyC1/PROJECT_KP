import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/circular_container.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/common/widgets/shimmer/shimmer.dart';
import 'package:project_uas/features/shop/controllers/banner_controller.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BPromoSlider extends StatelessWidget {
  const BPromoSlider({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());

    return Obx(
      () {
        // Loader
        if (controller.isLoading.value) return const BShimmerEffect(width: double.infinity, height: 190);

        // No data found
        if (controller.banners.isEmpty) {
          return const Center(child: Text('No Data Found!'));
        } else {
          return Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1,
                  onPageChanged: (index, _) => controller.updatePageIndicator(index)
                ),
                items: controller.banners.map((banners) => BRoundedImage(imageUrl: banners.imageUrl, isNetworkImage: true, 
                onPressed: () => Get.toNamed(banners.targetScreen))).toList(),
              ), 
              const SizedBox(height: BSize.spaceBtwItems),
              Center(
                child: Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < controller.banners.length; i++) 
                        BCircularContainer(
                          width: 20, 
                          height: 4, 
                          margin: const EdgeInsets.only(right: 10),
                          backgroundColor: controller.carousalcurrentIndex.value ==  i? BColors.primary : BColors.grey),
                      ]
                    ),
                  ),
                ),
              ]
            );
        }       
      }
    );
  }
}