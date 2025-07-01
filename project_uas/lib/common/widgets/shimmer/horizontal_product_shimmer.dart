import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/shimmer/shimmer.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BHorizontalProductShimmer extends StatelessWidget {
  const BHorizontalProductShimmer({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: BSize.spaceBtwSections),
      height: 120,
      child: ListView.separated(
        itemCount: itemCount,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) =>
            const SizedBox(width: BSize.spaceBtwItems),
        itemBuilder: (_, __) => const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            BShimmerEffect(width: 120, height: 120),
            SizedBox(width: BSize.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}