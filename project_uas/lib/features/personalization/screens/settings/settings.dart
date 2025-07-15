import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/data/banner/banner_repository.dart';
import 'package:project_uas/features/personalization/controllers/user_controller.dart';
import 'package:project_uas/features/shop/function/admin/admin_confirm_reservation_screen.dart';
import 'package:project_uas/features/shop/function/brand/delete_brand.dart';
import 'package:project_uas/features/shop/function/brand/upload_brand.dart';
import 'package:project_uas/features/shop/function/capster/delete_capster_sheet.dart';
import 'package:project_uas/features/shop/function/capster/upload_capster_dialog.dart';
import 'package:project_uas/features/shop/function/admin/admin_order_screen.dart';
import 'package:project_uas/features/shop/function/owner/register_admin_screen.dart';
import 'package:project_uas/features/shop/function/package/delete_package_sheet.dart';
import 'package:project_uas/features/shop/function/package/upload_package_dialog.dart';
import 'package:project_uas/features/shop/function/product/check_add_stock_screen.dart';
import 'package:project_uas/features/shop/function/product/product_delete.dart';
import 'package:project_uas/features/shop/function/product/product_edit.dart';
import 'package:project_uas/features/shop/function/product/product_upload_screen.dart';
import 'package:project_uas/features/personalization/screens/profile/profile.dart';
import 'package:project_uas/features/shop/controllers/theme_controller.dart';
import 'package:project_uas/features/shop/function/banner/delete_banner_sheet.dart';
import 'package:project_uas/features/shop/screens/cart/cart.dart';
import 'package:project_uas/features/shop/screens/chat/chat.dart';
import 'package:project_uas/features/shop/screens/order/order.dart';
import 'package:project_uas/features/shop/screens/reservation/reservation_history_user.dart';
import 'package:project_uas/features/shop/screens/results/order_result_screen.dart';
import 'package:project_uas/features/shop/screens/results/reservation_result_screen.dart';

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
    final isOwner = userController.user.value.role == 'owner';
    
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

                  // Customer
                  if (!isAdmin && !isOwner)
                  BSettingsMenuTile(
                    icon: Iconsax.message,
                    title: 'Chat',
                    subTitle: 'Contact Our Services!', 
                    onTap: () {
                      Get.to(() => const ChatScreen());
                    },               
                  ),
                  if (!isAdmin && !isOwner)
                  BSettingsMenuTile(
                    icon: Iconsax.shopping_cart, 
                    title: 'My cart', 
                    subTitle: "Add, remove products and have to checkout",
                    onTap: () => Get.to(() => const CartScreen())),
                  if (!isAdmin && !isOwner)
                  BSettingsMenuTile(
                    icon: Iconsax.bag_tick, 
                    title: "My Orders", 
                    subTitle: 'In progress and Completed Orders',
                    onTap: () => Get.to(() => const OrderScreen())),
                  if (!isAdmin && !isOwner)
                  BSettingsMenuTile(
                    icon: Iconsax.calendar, 
                    title: "My Reservations", 
                    subTitle: 'In progress and Past Reservations',
                    onTap: () => Get.to(() => const ReservationHistoryUser()),
                  ),


                  // Admin Featured
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.check,
                    title: 'Confirm Product',
                    subTitle: 'Confirmed Purchase Product',
                    onTap: () => Get.to(() => const AdminOrderScreen()),
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.check,
                    title: 'Confirm Reservation',
                    subTitle: 'Confirmed Reservation Product',
                    onTap: () => Get.to(() => const AdminConfirmReservationScreen()),
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Upload Banner',
                    subTitle: 'Upload Banner to your Cloud Firebase',
                    onTap: () async {
                      try {
                        final result = await BannerRepository.instance.uploadBanner(targetScreen: '/store');
                        if (result) {
                          Get.snackbar('Success', 'Banner berhasil diupload');
                        } else {
                          // User batalkan pemilihan gambar
                          Get.snackbar('Dibatalkan', 'Upload banner dibatalkan');
                        }
                      } catch (e) {
                        Get.snackbar('Error', e.toString());
                      }
                    },
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.trash,
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
                    icon: Iconsax.trash,
                    title: 'Delete Product',
                    subTitle: 'Delete individual or all products',
                    onTap: () => showDeleteProductSheet(context),
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Upload Brand',
                    subTitle: 'Upload Brand to your Cloud Firebase',
                    onTap: () => UploadBrandDialog.show(),
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.trash,
                    title: 'Delete Brand',
                    subTitle: 'Delete Brand from your Cloud Firebase',
                    onTap: () => showDeleteBrandSheet(context),
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.check,
                    title: 'Check And Add Stock Product',
                    subTitle: 'Edit Product from your Cloud Firebase',
                    onTap: () => Get.to(() => const CheckAddStockScreen()),
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.edit,
                    title: 'Edit Product',
                    subTitle: 'Edit Product from your Cloud Firebase',
                    onTap: () => Get.to(() => const ProductEditListScreen()), 
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Upload Capster',
                    subTitle: 'Upload New Capster to your Cloud Firebase',
                    onTap: () => UploadCapsterDialog.show(context),
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.trash,
                    title: 'Delete Capster',
                    subTitle: 'Delete Capster to your Cloud Firebase',
                    onTap: () => showDeleteCapsterSheet(context),
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'Upload Package',
                    subTitle: 'Upload New Package to your Cloud Firebase',
                    onTap: () =>  UploadPackageDialog.show(context),
                  ),
                  if (isAdmin)
                  BSettingsMenuTile(
                    icon: Iconsax.trash,
                    title: 'Delete Package',
                    subTitle: 'Delete Package to your Cloud Firebase',
                    onTap: ()  => fetchAndShowDeletePackageSheet(context),
                  ),

                  // Owner Featured
                  if (isOwner)
                  BSettingsMenuTile(
                    icon: Iconsax.edit,
                    title: 'Orders Result',
                    subTitle: 'Check Orders Result',
                    onTap: () => Get.to(() => const OrdersResultScreen()),
                  ),
                  if (isOwner)
                  BSettingsMenuTile(
                    icon: Iconsax.edit,
                    title: 'Reservations Result',
                    subTitle: 'Check Reservations Result',
                    onTap: () => Get.to(() => const ReservationsResultScreen()), 
                  ),
                  if (isOwner)
                  BSettingsMenuTile(
                    icon: Iconsax.edit,
                    title: 'Register Admin Account',
                    subTitle: 'Create Admin Account',
                    onTap: () => Get.to(() => const RegisterAdminScreen()), 
                  ),

                  /// App Settings
                  const SizedBox(height: BSize.spaceBtwSections),
                  const BSectionHeading(title: 'App Settings', showActionButton: false),
                  const SizedBox(height: BSize.spaceBtwItems),
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