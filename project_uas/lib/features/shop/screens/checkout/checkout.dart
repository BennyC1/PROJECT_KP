import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/features/shop/controllers/product/cart_controller.dart';
import 'package:project_uas/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:project_uas/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:project_uas/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:project_uas/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:project_uas/features/shop/screens/payment/payment_proof_screen.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';
import 'package:project_uas/utils/helpers/pricing_calculator.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final cartController = CartController.instance;
    final discount = cartController.getTotalDiscount();
    final subTotal = cartController.getOriginalTotalPrice();
    final tax = BPricingCalculator.calculateTax(subTotal, "Indonesia");
    final total = subTotal + tax - discount;

    final dark = BHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: BAppBar(showBackArrow: true, title: Text('Order Review', style: Theme.of(context).textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [
              /// -- Items in Cart
              const BCartItems(showAddRemoveButtons: false),
              const SizedBox (height: BSize.spaceBtwSections),

              // billing
              BRoundedContainer (
                showBorder: true,
                backgroundcolor: dark ? BColors.black : BColors.white,
                padding: const EdgeInsets.only(top: BSize.sm, bottom: BSize.sm, right: BSize.sm, left: BSize.md),
                child: const Column(
                  children: [
                    /// Pricing
                    SizedBox(height: BSize.spaceBtwItems),
                    BBillingAmountSection(),
                    SizedBox(height: BSize.spaceBtwItems),

                    /// Divider
                    Divider(),

                    // Payment Methods
                    BBillingPaymentSection(),
                    SizedBox (height: BSize.spaceBtwItems),

                    Divider(),

                    // Address
                    BBillingAddressSection(),
                    
                  ]
                )
              )
            ]
          ), 
        ), 
      ),
      
      // check out button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(BSize.defaultSpace),
        child: ElevatedButton( 
          onPressed: subTotal > 0 
            ? () => Get.to(() => PaymentProofScreen(totalAmount: total))
            : () => BLoaders.warningSnackBar(title: 'Empty Cart', message: 'Add item in the cart in order to proceed'),
          child: Text('Checkout ${currencyFormatter.format(total)}'),
        ),
      ),
    );
  }
}


