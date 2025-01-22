import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/products/cart/coupon_widget.dart';
import 'package:project_uas/common/widgets/success_screen/success_screen.dart';
import 'package:project_uas/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:project_uas/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:project_uas/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:project_uas/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:project_uas/navigation_menu.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen( {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: BAppBar(showBackArrow: true, title: Text('Order Review', style: Theme.of(context).textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets. all (BSize.defaultSpace),
          child: Column(
            children: [
              /// -- Items in Cort
              const BCartItems(showAddRemoveButtons: false),
              const SizedBox (height: BSize.spaceBtwSections),

              // coupon
              BCouponCode(),
              const SizedBox (height: BSize. spaceBtwSections),

              // billing
              BRoundedContainer (
                showBorder: true,
                backgroundcolor: dark ? BColors.black : BColors.white,
                child: const Column(
                  children: [
                    /// Pricing
                    BBillingAmountSection(),
                    SizedBox(height: BSize.spaceBtwItems),

                    /// Divider
                    Divider(),
                    SizedBox (height: BSize.spaceBtwItems),

                    // Payment Methods
                    BBillingPaymentSection(),
                    SizedBox (height: BSize.spaceBtwItems),

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
        child: ElevatedButton(onPressed: () => Get.to(() => SuccessScreen(
          image: BImages.successfullyRegisterAnimation,
          title: 'Payment Success!',
          subTitle: 'Your Item Will be Shipped Soon!~',
          onPressed: () => Get.offAll(() => const NavigationMenu()),
        )), child: const Text('Checkout \$256.0')),
      ),
    );
  }
}


