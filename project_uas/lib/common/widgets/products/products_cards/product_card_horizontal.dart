import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/images/rounded_image.dart';
import 'package:project_uas/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:project_uas/common/widgets/products/products_cards/add_to_cart_button.dart';
import 'package:project_uas/common/widgets/texts/brand_title_text_with_verification.dart';
import 'package:project_uas/common/widgets/texts/product_price_text.dart';
import 'package:project_uas/common/widgets/texts/product_title_text.dart';
import 'package:project_uas/features/shop/controllers/product/product_controller.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/features/shop/screens/product_details/product_detail.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BProductCardHorizontal extends StatelessWidget {
  const BProductCardHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final dark = BHelperFunctions.isDarkMode(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    
    return InkWell(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        width: 310,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BSize.productImageRadius),
          color: dark ? BColors. darkerGrey : BColors.softGrey,
        ),
        child: Row (
          children: [
            /// Thumbnail
            BRoundedContainer (
              height: 120,
              padding: const EdgeInsets.all(BSize.sm),
              backgroundcolor: dark ? BColors.dark : BColors.light,
              child: Stack (
                children: [
                  /// -- Thumbnail Image
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: BRoundedImage(imageUrl: product.thumbnail, applyImageRadius: true, isNetworkImage: true,)
                  ),
      
                  /// Sale Tag
                  if (salePercentage != null)
                    Positioned (
                      top: 12,
                      child: BRoundedContainer (
                        radius: BSize.sm,
                        backgroundcolor: BColors.secondary.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(horizontal: BSize.sm, vertical: BSize.xs),
                        child: Text('$salePercentage%', style: Theme.of(context).textTheme.labelLarge!.apply(color:BColors.black)),
                      ),
                    ),
      
                  /// Favourite Icon Button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: BFavouriteIcon(productId: product.id),        
                  ),
                ]
              )
            ),   
      
            // detail
            SizedBox(
              width: 172,
              child: Padding(
                padding: const EdgeInsets.only(top: BSize.sm, left: BSize.sm),
                child: Column (
                  children: [
                    Column (
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BProductTitleText(title: product.title, smallsize: true),
                        const SizedBox(height: BSize. spaceBtwItems / 2),
                        BBrandTitleWithVerifiedIcon(title: product.brand!.name),
                      ],
                    ),
      
                    const Spacer (),
      
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: BSize.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Harga asli dicoret, tampil hanya jika ada sale
                                if (product.productType == ProductType.single.toString() && product.salePrice > 0)
                                  Text(
                                    currencyFormatter.format(product.price),
                                    style: Theme.of(context).textTheme.labelMedium!.apply(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                // Harga diskon (harga aktif)
                                BProductPriceText(price: controller.getProductPrice(product)),
                              ],
                            ),
                          ),
                        ),
      
                        /// Add to cart
                        ProductCardAddToCartButton(product: product),
                      ],               
                    )
                  ]
                )
              )
            )
          ]
        )
      ),
    );
  }
}
        
    
