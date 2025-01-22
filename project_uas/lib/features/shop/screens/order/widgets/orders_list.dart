import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';


class BOrderListItems extends StatelessWidget {
  const BOrderListItems({super.key});
  
  @override
  Widget build (BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return ListView.separated(
      shrinkWrap: true,
      itemCount: 1,
      separatorBuilder: (_, __) => const SizedBox(height: BSize.spaceBtwItems),
      itemBuilder: (_, index) => BRoundedContainer(
        showBorder: true,
        padding: const EdgeInsets.all(BSize.md),
        backgroundcolor: dark? BColors.dark: BColors.light,
        child: Column (
          mainAxisSize: MainAxisSize.min,
          children: [
            /// row 1
            Row(
              children: [
                /// 1 Icon
                const Icon(Iconsax.ship),
                const SizedBox (width: BSize.spaceBtwItems / 2),
      
                /// 2 Status & Date
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete',
                        style: Theme.of(context).textTheme.bodyLarge!.apply(color: BColors.primary, fontWeightDelta: 1),
                      ),
                      Text('17 Sept 2024', style: Theme.of(context).textTheme.headlineSmall),
                    ]
                  ),
                ),
                // 3 icon
                IconButton(onPressed: () {}, icon: const Icon(Iconsax.arrow_right_34, size: BSize.iconSm)),
              ]
            ),
            const SizedBox(height: BSize.spaceBtwItems),
      
            /// row 2
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      /// 1 Icon
                      const Icon(Iconsax.tag),
                      const SizedBox (width: BSize.spaceBtwItems / 2),
                  
                      /// 2 Status & Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order', style: Theme.of(context).textTheme.labelMedium),
                            Text('[#2bsbd]', style: Theme.of(context).textTheme.titleMedium),
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      /// 1 Icon
                      const Icon(Iconsax.calendar),
                      const SizedBox (width: BSize.spaceBtwItems / 2),
                  
                      /// 2 Status & Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Shipping Data!', style: Theme.of(context).textTheme.labelMedium),
                            Text('17-09-2024', style: Theme.of(context).textTheme.titleMedium),
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
              ],
            )
          ]
        )
      ),
    );
  }
}
