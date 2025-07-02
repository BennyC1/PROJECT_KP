import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/features/shop/controllers/product/checkout_controller.dart';
import 'package:project_uas/features/shop/models/payment_method_model.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BPaymentTile extends StatelessWidget {
  const BPaymentTile({super.key, required this.paymentMethod});

  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        controller.selectedPaymentMethod.value = paymentMethod;
        Get.back();
      },
      leading: BRoundedContainer(
        width: 60,
        height: 40,
        backgroundcolor: BHelperFunctions.isDarkMode(context) ? BColors.light : BColors.white,
        padding: const EdgeInsets.all(BSize.sm),
        child: Image(image: AssetImage(paymentMethod.image), fit: BoxFit.contain),
      ), 
      title: Text (paymentMethod.name),
      trailing: const Icon(Iconsax.arrow_right_34),
    );
  }
}
