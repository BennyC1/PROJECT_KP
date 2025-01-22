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
                const BSectionHeading(title: 'Detail', showActionButton: false),
                const SizedBox(width: BSize.spaceBtwItems),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const BProductTitleText(title: "Harga : ", smallsize: true),

                        /// Actual Price
                        Text(
                          '\Rp 937.500',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(width: BSize.spaceBtwItems),

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
              title: 'Introducing the Amaron AGS Battery – your ultimate power source for an uncompromised driving experience, now fortified with the innovative Dura Frame technology.',
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
                BChoiceChip(text: 'Aki Mobil', selected: true, onSelected: (value){}),
              ],
            )
          ]
        )
      ],
    );
  }
}
    
  
