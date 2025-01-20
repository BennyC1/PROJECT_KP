import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BBillingPaymentSection extends StatelessWidget {
  const BBillingPaymentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions. isDarkMode(context);

    return Column(
      children: [
        BSectionHeading(title: 'Payment Method', buttonTitle: 'Change', onPressed: () {}),
        const SizedBox (height: BSize.spaceBtwItems / 2),
        Row(
          children: [
            BRoundedContainer(
              width: 68,
              height: 35,
              backgroundcolor: dark ? BColors.light : BColors.white,
              padding: const EdgeInsets.all(BSize.sm),
              child: const Image(image: AssetImage(BImages.paypal), fit: BoxFit.contain),
            ), 
            const SizedBox(width: BSize.spaceBtwItems / 2),
            Text( "Paypal", style: Theme.of(context).textTheme.bodyLarge),
          ]
        )
      ]
    );
  }
}