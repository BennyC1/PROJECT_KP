import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/data/banner/banner_repository.dart';
import 'package:project_uas/features/personalization/controllers/user_controller.dart';
import 'package:project_uas/features/personalization/screens/product/product_upload_screen.dart';
import 'package:project_uas/features/personalization/screens/profile/profile.dart';
import 'package:project_uas/features/shop/controllers/theme_controller.dart';
import 'package:project_uas/features/shop/screens/banner/delete_banner_sheet.dart';
import 'package:project_uas/features/shop/screens/cart/cart.dart';
import 'package:project_uas/features/shop/screens/chat/chat.dart';
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
    final themeController = Get.find<ThemeController>();
    final userController = Get.find<UserController>();
    final isAdmin = userController.user.value.role == 'admin';
    
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

                  if (!isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.message,
                    title: 'Chat',
                    subTitle: 'Contact Our Services!', 
                    onTap: () {
                      Get.to(() => const ChatScreen());
                    },               
                  ),
                  if (!isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.shopping_cart, 
                    title: 'My cart', 
                    subTitle: "Add, remove products and have to checkout",
                    onTap: () => Get.to(() => const CartScreen())),
                  if (!isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.bag_tick, 
                    title: "My Orders", 
                    subTitle: 'In progress and Completed Orders',
                    onTap: () => Get.to(() => const OrderScreen())),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Upload Banner',
                    subTitle: 'Upload Banner to your Cloud Firebase',
                    onTap: () async {
                      try {
                        await BannerRepository.instance.uploadBanner(targetScreen: '/store');
                        Get.snackbar('Success', 'Banner berhasil diupload');
                      } catch (e) {
                        Get.snackbar('Error', e.toString());
                      }
                    },
                  ),
                 if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Delete Banner',
                    subTitle: 'Delete per banner or all at once',
                    onTap: () => showDeleteBannerSheet(context),
                  ),                 
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Upload Product',
                    subTitle: 'Upload Product to your Cloud Firebase',
                    onTap: () => Get.to(() => const ProductUploadScreen()),
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Delete Product',
                    subTitle: 'Delete Product to your Cloud Firebase',
                    onTap: () {
                      // hanya bisa dipakai admin
                    },
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Upload Brand',
                    subTitle: 'Upload Brand to your Cloud Firebase',
                    onTap: () {
                      // hanya bisa dipakai admin
                    },
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Delete Brand',
                    subTitle: 'Delete Brand to your Cloud Firebase',
                    onTap: () {
                      // hanya bisa dipakai admin
                    },
                  ),

                  /// App Settings
                  const SizedBox(height: BSize.spaceBtwSections),
                  const BSectionHeading(title: 'App Settings', showActionButton: false),
                  const SizedBox(height: BSize.spaceBtwItems),
                  if (!isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.notification, 
                    title: "Notifications", 
                    subTitle: 'Set any kind of notification message',
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                  Obx(() => BSettingsMenuTile(
                    icon: Iconsax.notification,
                    title: "Dark Mode",
                    subTitle: 'Set light and dark background!',
                    trailing: Switch(
                      value: themeController.isDarkMode.value,
                      onChanged: (value) => themeController.toggleTheme(value),
                    ),
                  )),

                  // Logout Button
                  const SizedBox(height: BSize.spaceBtwSections),
                  SizedBox(
                    width: double. infinity,
                    child: OutlinedButton(onPressed: () async {
                    await AuthenticationRepository.instance.logout();}, 
                    child: const Text('Logout')),
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


