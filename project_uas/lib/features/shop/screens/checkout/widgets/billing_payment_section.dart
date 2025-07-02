import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/controllers/product/checkout_controller.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BBillingPaymentSection extends StatelessWidget {
  const BBillingPaymentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);
    final controller = Get.put(CheckoutController());

    return Column(
      children: [
        BSectionHeading(title: 'Payment Method', buttonTitle: 'Change', onPressed: () => controller.selectPaymentMethod(context)),
        const SizedBox (height: BSize.spaceBtwItems / 2),
        Obx(() =>
          Row(
            children: [
              BRoundedContainer(
                width: 60,
                height: 35,
                backgroundcolor: dark ? BColors.light : BColors.white,
                padding: const EdgeInsets.all(BSize.sm),
                child: Image(image: AssetImage(controller.selectedPaymentMethod.value.image), fit: BoxFit.contain),
              ), 
              const SizedBox(width: BSize.spaceBtwItems / 2),
              Text(controller.selectedPaymentMethod.value.name, style: Theme.of(context).textTheme.bodyLarge),
            ]
          ),
        )
      ]
    );
  }
}