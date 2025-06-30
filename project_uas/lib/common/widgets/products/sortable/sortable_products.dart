import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:project_uas/features/shop/controllers/all_product_controller.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BSortableProducts extends StatelessWidget {
  const BSortableProducts({
    super.key, required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    controller.assignProducts(products);
    return Column (
      children: [
        /// Dropdown
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          value: controller.selectedSortOption.value,
          onChanged: (value) {
            controller.sortProducts(value!);
          },
          items: ['Name', 'Higher Price', 'Lower Price', 'Sale', 'Newest', 'Popularity']
            .map ( (option) => DropdownMenuItem(value: option, child: Text(option))).
            toList()
        ),
        const SizedBox(height: BSize.spaceBtwSections),

        /// Products
        Obx(() => BGridLayout (itemCount: controller.products.length, itemBuilder: ( _, index) => BProductCardVertical(product: controller.products[index]))),
      ]
    );
  }
}

