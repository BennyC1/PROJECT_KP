
import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';

import 'shimmer.dart';

class BBrandsShimmer extends StatelessWidget {
  const BBrandsShimmer ({super.key, this.itemCount = 4 });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return BGridLayout (
      mainAxisExtent: 80,
      itemCount: itemCount,
      itemBuilder: (_, __) => const BShimmerEffect(width: 300, height: 80),
    );
  }
}