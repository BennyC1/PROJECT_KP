import 'package:flutter/widgets.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/utils/constants/sized.dart';

import 'shimmer.dart';

class BVerticalProductShimmer extends StatelessWidget {
  const BVerticalProductShimmer ({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return BGridLayout (
      itemCount: itemCount,
      itemBuilder: (_, __ ) => const SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            BShimmerEffect(width: 180, height: 180),
            SizedBox(height: BSize.spaceBtwItems),

            /// Text
            BShimmerEffect(width: 160, height: 15),
            SizedBox(height: BSize.spaceBtwItems / 2),
            BShimmerEffect(width: 110, height: 15),
          ],
        )
      )
    );
  }
}
