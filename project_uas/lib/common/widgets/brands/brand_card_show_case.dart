import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/brands/brand_card.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BBrandShowcase extends StatelessWidget {
  const BBrandShowcase({
    super.key, 
    required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return BRoundedContainer (
      showBorder: true,
      borderColor: BColors.darkGrey,
      backgroundcolor: Colors.transparent,
      margin: const EdgeInsets. only(bottom: BSize.spaceBtwItems),
      child: Column(
        children: [
          /// Brand with Products Count
          const BBrandCard(showBorder: false),
          const SizedBox(height: BSize.spaceBtwItems),

          /// Brand Top 3 Product Images
          Row(
            children: images.map((image) =>  brandTopProductImageWidget(image, context)).toList()
          ),
        ],
      ),
    );
  }

  Widget brandTopProductImageWidget(String image, context) {
    return Expanded (
      child: BRoundedContainer (
        height: 100,
        backgroundcolor: BHelperFunctions.isDarkMode(context) ? BColors.darkerGrey : BColors.light,
        margin: const EdgeInsets.only(right: BSize.sm),
        padding: const EdgeInsets.all(BSize.md),
        child: Image(fit: BoxFit.contain, image: AssetImage(image)),
      ),
    );
  }
}