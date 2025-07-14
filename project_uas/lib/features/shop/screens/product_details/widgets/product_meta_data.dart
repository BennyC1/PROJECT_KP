import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/images/circular_image.dart';
import 'package:project_uas/common/widgets/texts/brand_title_text_with_verification.dart';
import 'package:project_uas/common/widgets/texts/product_price_text.dart';
import 'package:project_uas/common/widgets/texts/product_title_text.dart';
import 'package:project_uas/features/shop/controllers/product/product_controller.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BProductMetaData extends StatelessWidget {
  const BProductMetaData({
    super.key, required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final darkMode = BHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sale Price
        Row(
          children: [
            /// Sale Tag
            if (salePercentage != null)
            BRoundedContainer (
              radius: BSize.sm,
              backgroundcolor: BColors.secondary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(horizontal: BSize.sm, vertical: BSize.xs),
              child: Text('$salePercentage%', style: Theme.of(context).textTheme.labelLarge!.apply(color: BColors.black)),
            ),
          ]
        ),  
        const SizedBox(width: BSize.spaceBtwItems),

        /// Price
        if(product.productType == ProductType.single.toString() && product.salePrice > 0)
          Text(currencyFormatter.format(product.price), style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough)),
        if(product.productType == ProductType.single.toString() && product.salePrice > 0) const SizedBox(width: BSize.spaceBtwItems),
        BProductPriceText(price: controller.getProductPrice(product), isLarge: true),
        
        const SizedBox(height: BSize. spaceBtwItems / 1.5),

        /// Title
        BProductTitleText(title: product.title),
        const SizedBox(height: BSize.spaceBtwItems / 1.5),

        /// Stock Status
        Row(
          children: [
            const BProductTitleText(title: 'Status :'),
            const SizedBox(width: BSize.spaceBtwItems),
            Text(controller.getProductStockStatus(product.stock), style: Theme.of(context).textTheme.titleMedium),
          ]
        ),
            
        const SizedBox(height: BSize.spaceBtwItems / 2),

        /// Brand
        Row(
          children: [
            BCircularImage (
              image: product.brand != null ? product.brand!.image : '',
              isNetworkImage: true,
              width: 32,
              height: 32,
              overlayColor: darkMode ? BColors.white : BColors.black,
            ),
            BBrandTitleWithVerifiedIcon(title: product.brand != null ? product.brand!.name : '', brandTextSize: TextSizes.medium),
          ],
        ),
      ]
    );
  }
}