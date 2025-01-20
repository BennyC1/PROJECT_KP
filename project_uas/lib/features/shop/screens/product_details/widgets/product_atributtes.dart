import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/chips/choice_chip.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/texts/product_price_text.dart';
import 'package:project_uas/common/widgets/texts/product_title_text.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BProductAttributes extends StatelessWidget {
  const BProductAttributes({super.key}) ;

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions. isDarkMode(context);

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
                const BSectionHeading(title: 'Harga', showActionButton: false),
                const SizedBox(width: BSize.spaceBtwItems),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const BProductTitleText(title: "Price : ", smallsize: true),

                        /// Actual Price
                        Text(
                          '\$25',
                          style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough),
                        ),
                        const SizedBox(width: BSize.spaceBtwItems),

                        /// Sale Price
                        const BProductPriceText(price: '20'),
                      ],
                    ),
                    /// Stock
                    Row(
                      children: [
                        const BProductTitleText(title: 'Stock :', smallsize: true),
                        Text(' In Stock', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ],
                ),
              ],
            ),


            // Variation Description
            const BProductTitleText(
              title: 'cuma bisa sampe 4 baris ni desk pendek',
              smallsize: true,
              maxLines: 4,
            ),
              
            ],
          ),
        ),
        const SizedBox(height: BSize.spaceBtwItems / 2),

        // Atribut
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BSectionHeading(title: 'Jenis', showActionButton: false),
            const SizedBox(height: BSize.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                BChoiceChip(text: 'aki-aki', selected: true, onSelected: (value){}),
                BChoiceChip(text: 'aki-aki', selected: false, onSelected: (value){}),
                BChoiceChip(text: 'aki-aki', selected: false, onSelected: (value){}),
                BChoiceChip(text: 'aki-aki', selected: true, onSelected: (value){}),
                BChoiceChip(text: 'aki-aki', selected: false, onSelected: (value){}),
                BChoiceChip(text: 'aki-aki', selected: true, onSelected: (value){}),
                BChoiceChip(text: 'aki-aki', selected: false, onSelected: (value){}),
                BChoiceChip(text: 'aki-aki', selected: false, onSelected: (value){}),
                BChoiceChip(text: 'aki-aki', selected: true, onSelected: (value){}),
              ],
            )
          ]
        )
      ],
    );
  }
}
    
  
