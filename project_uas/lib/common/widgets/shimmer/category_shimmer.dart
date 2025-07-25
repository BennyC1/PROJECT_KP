import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/sized.dart';

import 'shimmer.dart';

class BCategoryShimmer extends StatelessWidget {
  const BCategoryShimmer ({
    super. key,
    this.itemCount = 6,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox (
      height: 80,
      child: ListView. separated(
        shrinkWrap: true,
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __ ) => const SizedBox(width: BSize.spaceBtwItems),
        itemBuilder: (_, __ ) {
          return const Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              BShimmerEffect(width: 55, height: 55, radius: 55),
              SizedBox(height: BSize.spaceBtwItems / 2), 

              /// Text
              BShimmerEffect(width: 55, height: 8),
            ],
          );
        }
      )
    );
  }
} 
