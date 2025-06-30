import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/icons/circular_icon.dart';
import 'package:project_uas/features/shop/controllers/product/favourites_controller.dart';
import 'package:project_uas/utils/constants/colors.dart';

class BFavouriteIcon extends StatelessWidget {
  const BFavouriteIcon({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouritesController ());
    return Obx(
      () => BCircularIcon(
        icon: controller.isFavourite(productId) ? Iconsax.heart5 : Iconsax.heart,
        color: controller.isFavourite(productId) ? BColors.error : null,
        onPressed: () => controller. toggleFavoriteProduct(productId)
      ),
    );
  }
}
