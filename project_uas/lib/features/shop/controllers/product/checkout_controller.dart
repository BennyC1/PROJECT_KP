import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/list_tiles/payment_tile.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/shop/models/payment_method_model.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';

class CheckoutController extends GetxController{
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    selectedPaymentMethod.value = PaymentMethodModel(image: BImages.qris, name: 'Qris');
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(BSize.Lg),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BSectionHeading(title: 'Select Payment Method', showActionButton: false),
              const SizedBox(height: BSize.spaceBtwSections),
              BPaymentTile(paymentMethod: PaymentMethodModel(name: 'Qris', image: BImages.qris))
            ]
          )
        )
      ),
    );
  }
}