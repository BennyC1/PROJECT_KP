import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/circular_container.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/features/authentication/shop/controllers/home_controllers.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BPromoSlider extends StatelessWidget {
  const BPromoSlider({
    super.key, required this.banners,
  });

  final List<String> banners;
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            onPageChanged: (index, _) => controller.updatePageIndicator(index)
          ),
          items: banners.map((url) => BRoundedImage(imageUrl: url)).toList(),
        ), // CarouselSLider
        const SizedBox(height: BSize.spaceBtwItems),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < banners.length; i++) 
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