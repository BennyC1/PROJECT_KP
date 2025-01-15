import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/images/circular_image.dart';
import 'package:project_uas/common/widgets/texts/brand_title_text_with_verification.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';


class BBrandCard extends StatelessWidget {
  const BBrandCard({
    super.key, 
    required this.showBorder, 
    this.onTap,
  });

  final bool showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = BHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () {},
      child: BRoundedContainer (
        padding: EdgeInsets.all (BSize.sm),
        showBorder: true,
        backgroundcolor: Colors. transparent,
        child: Row(
          children:  [
            /// Icon
            Flexible(
              child: BCircularImage (
                isNetworkImage: false,
                image: BImages. clothIcon,
                backgroundColor: Colors.transparent,
                overlayColor: isDark ? BColors.white : BColors.black,
                ),
            ),
            const SizedBox(width: BSize.spaceBtwItems / 2),
        
            // TEXT
            Expanded(
              child: Column (
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BBrandTitleWithVerifiedIcon(title: 'Nike', brandTextSize: TextSizes.large),
                  Text(
                    '256 products',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                ]
              ),
            )
          ]
        ),
      ),
    );
  }
}