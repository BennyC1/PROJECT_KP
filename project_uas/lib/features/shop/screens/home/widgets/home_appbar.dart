import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:project_uas/features/personalization/controllers/user_controller.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/common/widgets/shimmer/shimmer.dart';

class BHomeAppBar extends StatelessWidget {
  const BHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return BAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(BText.homeAppbarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: BColors. grey)),
          Obx(() {
            if(controller.profileLoading.value) {
              return const BShimmerEffect(width: 80, height: 15);
            }
            return Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: BColors.white));
          }),
        ],
      ),
      actions: [
        BCartCounterIcon(iconColor: BColors.white, onPressed: () {},),
      ]
    );
  }
}