import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/sized.dart';

import 'shimmer.dart';

class BBoxesShimmer extends StatelessWidget {
  const BBoxesShimmer({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: BShimmerEffect(width: 150, height: 110)),
            SizedBox(width: BSize.spaceBtwItems),
            Expanded(child: BShimmerEffect(width: 150, height: 110)),
            SizedBox(width: BSize.spaceBtwItems),
            Expanded(child: BShimmerEffect(width: 150, height: 110)),
          ],
        ),
      ],
    );
  }
}
    
