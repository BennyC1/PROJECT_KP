import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/texts/product_price_text.dart';
import 'package:project_uas/common/widgets/texts/product_title_text.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/controllers/product/product_controller.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BProductAttributes extends StatelessWidget {
  const BProductAttributes({super.key, required this.product}) ;

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);
    final controller = ProductController.instance;

    return Column (
      children: [

        //Selected Attribute Pricing & Description
        BRoundedContainer (
          padding: const EdgeInsets. all(BSize.md),
          backgroundcolor: dark ? BColors.darkerGrey : BColors.grey,
          child: Column(
            children: [

              /// Title, Price and Stock Staus
              Row (
              children: [
                const BSectionHeading(title: 'Detail', showActionButton: false),
                const SizedBox(width: BSize.spaceBtwItems),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const BProductTitleText(title: "Harga :", smallsize: true),

                        /// Actual Price
                        if(product.productType == ProductType.single.toString() && product.salePrice > 0)
                        const Text(""),
                        BProductPriceText(price: controller.getProductPrice(product)),
                        
                        const SizedBox(width: BSize.spaceBtwItems),
                      ],
                    ),
                    /// Stock
                    Row(
                      children: [
                        const BProductTitleText(title: 'Stock : ', smallsize: true),
                        Text(controller.getProductStockStatus(product.stock), style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ], 
                ),
              ],
            ),

            const SizedBox(height: BSize.spaceBtwItems / 1.5),

            // Variation Description
            BProductTitleText(
              title: product.descriptiontitle ?? '',
              smallsize: true,
              maxLines: 4,
            ),
              
            ],
          ),
        ),
        const SizedBox(height: BSize.spaceBtwItems / 2),

        // Atribut
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     const BSectionHeading(title: 'Jenis', showActionButton: false),
        //     const SizedBox(height: BSize.spaceBtwItems / 2),
        //     Wrap(
        //       spacing: 8,
        //       children: [
        //         BChoiceChip(text: '', selected: true, onSelected: (value){}),
        //       ],
        //     )
        //   ]
        // )
      ],
    );
  }
}
    
  
