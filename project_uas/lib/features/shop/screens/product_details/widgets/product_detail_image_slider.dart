import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/custom_shape/curved_edges/curved_edges_widget.dart';
import 'package:project_uas/common/widgets/icons/circular_icon.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BProductImageSlider extends StatelessWidget {
  const BProductImageSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return BCurvedEdgesWidget(
      child: Container (
        color: dark ? BColors.darkerGrey : BColors.light,
        child: Stack(
          children: [
    
            /// Main Large Image
            const SizedBox(
              height: 408,
              child: Padding(
                padding: EdgeInsets.all (BSize. productImageRadius * 2),
                child: Center(child: Image(image: AssetImage(BImages.productImage5))),
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
                      itemCount: 6,
                      shrinkWrap: true,
                      scrollDirection: Axis. horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox (width: BSize. spaceBtwItems),
                      itemBuilder: (_, index) => BRoundedImage(
                      width: 80,
                      backgroundColor: dark ? BColors. dark : BColors. white,
                      border: Border.all(color: BColors.primary),
                      padding: const EdgeInsets. all(BSize.sm),
                      imageUrl: BImages.productImage3,
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