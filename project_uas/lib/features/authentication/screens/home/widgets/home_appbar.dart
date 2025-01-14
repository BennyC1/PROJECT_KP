import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/products_cart/cart_menu_icon.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/text_string.dart';

class BHomeAppBar extends StatelessWidget {
  const BHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(BText.homeAppbarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: BColors. grey)),
          Text(BText.homeAppbarSubTitle, style: Theme.of(context).textTheme.headlineSmall!.apply(color: BColors.white)),
        ],
      ),
      actions: [
        BCartCounterIcon(iconColor: BColors.white, onPressed: () {  },),
      ]
    );
  }
}