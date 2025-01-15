
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/shop/screens/home/home.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/icons/circular_icon.dart';
import '../../../../common/widgets/layouts/grid.layout.dart';
import '../../../../common/widgets/products/products_cards/product_card_vertical.dart';
import '../../../../utils/constants/sized.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar (
        title: Text('Wishlist', style: Theme. of(context). textTheme. headlineMedium),
        actions: [
          BCircularIcon(icon: Iconsax.add, onPressed: () => Get.to(const HomeScreen())),
        ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets. all(BSize. defaultSpace),
          child: Column(
            children: [BGridLayout(itemCount: 3, itemBuilder: (_, index) => const BProductCardVertical())],
          ),
        ),
      ), 
   );  
  }
}