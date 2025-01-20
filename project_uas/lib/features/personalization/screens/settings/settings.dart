
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/personalization/screens/profile/profile.dart';
import 'package:project_uas/features/shop/screens/cart/cart.dart';
import 'package:project_uas/features/shop/screens/order/order.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shape/containers/primary_header_container.dart';
import '../../../../common/widgets/list_tiles/setting_menu_tile.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sized.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: SingleChildScrollView(
        child: Column(
          children: [
            BPrimaryHeaderContainer(
              child: Column(
                children: [
                  // Appbar Atas
                  BAppBar(title: Text( "Account", style: Theme.of(context).textTheme.headlineMedium!.apply(color: BColors.white))),

                  /// User Profile Cord
                  BUserProfileTile(onPressed: () => Get.to(() => const ProfileScreen())),
                  const SizedBox(height: BSize.spaceBtwSections),
                ],
              ),
            ),

            /// Body
            Padding(
              padding: const EdgeInsets.all(BSize. defaultSpace),
              child: Column(
                children: [
                  // Account Settings
                  const BSectionHeading(title: 'Account Settings', showActionButton: false),
                  const SizedBox(height: BSize.spaceBtwSections),

                  const BSettingsMenuTile(
                    icon: Iconsax.safe_home, 
                    title: 'My Adrresses' , 
                    subTitle: 'Set Shopping delivery address'),
                  BSettingsMenuTile(
                    icon: Iconsax.shopping_cart, 
                    title: 'My cart', 
                    subTitle: "Add, remove products and hove to checkout",
                    onTap: () => Get.to(() => const CartScreen())),
                  BSettingsMenuTile(
                    icon: Iconsax.bag_tick, 
                    title: "My Orders", 
                    subTitle: 'In progress and Completed Orders',
                    onTap: () => Get.to(() => const OrderScreen())),
                  const BSettingsMenuTile(
                    icon: Iconsax.bank, 
                    title: 'Bank Account', 
                    subTitle: 'Withdraw balance to registered bank account'),
                  const BSettingsMenuTile(
                    icon: Iconsax.discount_shape, 
                    title: "My Coupons", 
                    subTitle: 'List of all the discounted coupons'),
                  const BSettingsMenuTile(
                    icon: Iconsax.notification, 
                    title: "Notifications", 
                    subTitle: 'Set any kind of notification message'),
                  const BSettingsMenuTile(
                    icon: Iconsax.security_card, 
                    title: "Account Privacy", 
                    subTitle: 'Manage data usage and connected accounts'),

                  /// App Settings
                  const SizedBox(height: BSize.spaceBtwSections),
                  const BSectionHeading(title: 'App Settings', showActionButton: false),
                  const SizedBox(height: BSize.spaceBtwItems),
                  const BSettingsMenuTile(icon: Iconsax.document_upload, title: 'Load Data', subTitle: 'Upload Data to your Cloud Firebase'),
                  BSettingsMenuTile(
                    icon: Iconsax.location,
                    title: 'Geolocation',
                    subTitle: 'Set recommendation based on location!',
                    trailing: Switch(value: true, onChanged: (value) {}),
                  ),
                  BSettingsMenuTile(
                    icon: Iconsax.image,
                    title: "HD Image Quality",
                    subTitle: 'Set image quality to be seen',
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),

                  // Logout Button
                  const SizedBox(height: BSize.spaceBtwSections),
                  SizedBox(
                    width: double. infinity,
                    child: OutlinedButton(onPressed: (){}, child: const Text( 'Logout' )),
                  ),
                  const SizedBox(height: BSize.spaceBtwSections * 2.5),
                ]
              ), 
            )
          ],
        ),
      ), 
    );
  }
}


