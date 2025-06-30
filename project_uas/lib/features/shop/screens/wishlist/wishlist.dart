import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:project_uas/features/shop/controllers/product/favourites_controller.dart';
import 'package:project_uas/features/shop/screens/home/home.dart';
import 'package:project_uas/navigation_menu.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/helpers/cloud_helper_functions.dart';
import 'package:project_uas/utils/loaders/animation_loader.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/icons/circular_icon.dart';
import '../../../../common/widgets/layouts/grid.layout.dart';
import '../../../../common/widgets/products/products_cards/product_card_vertical.dart';
import '../../../../utils/constants/sized.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavouritesController.instance;
    
    return Scaffold(
      appBar: BAppBar (
        title: Text('Wishlist', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          BCircularIcon(icon: Iconsax.add, onPressed: () => Get.to(const HomeScreen())),
        ]
      ),

      // BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets. all(BSize. defaultSpace),

          /// Products Grid
          child: Obx(
            () => FutureBuilder(
              future: controller.favoriteProducts(),
              builder: (context, snapshot) {
                /// Nothing Found Widget
                final emptyWidget = BAnimationLoaderWidget(
                  text: 'Whoops! Wishlist is Empty....',
                  animation: BImages.pencilAnimation,
                  showAction: true,
                  actionText: 'Let\'s add some',
                  onActionPressed: () => Get.off(() => const NavigationMenu()),
                ); 
            
                const loader = BVerticalProductShimmer(itemCount: 6);
                final widget = BCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader, nothingFound: emptyWidget);
                if (widget != null) return widget;
            
                final products= snapshot.data!;
                return BGridLayout(
                  itemCount: products.length,
                  itemBuilder: (_, index) => BProductCardVertical(product: products[index]));
              }
            ),
          ), 
        ), 
      ),
    );  
  }
}