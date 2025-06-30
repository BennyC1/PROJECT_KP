import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/sized.dart';

import 'shimmer.dart';

class BListTileShimmer extends StatelessWidget {
  const BListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row (
          children: [
            BShimmerEffect(width: 50, height: 50, radius: 50),
            SizedBox(width: BSize.spaceBtwItems),
            Column (
              children: [
                BShimmerEffect(width: 100, height: 15),
                SizedBox(height: BSize.spaceBtwItems / 2),
                BShimmerEffect(width: 80, height: 12),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
