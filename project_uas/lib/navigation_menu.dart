import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/shop/screens/home/home.dart';
import 'package:project_uas/features/personalization/screens/settings/settings.dart';
import 'package:project_uas/features/shop/screens/reservation/reservation.dart';
import 'package:project_uas/features/shop/screens/store/store.dart';
import 'package:project_uas/features/shop/screens/wishlist/wishlist.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = BHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: darkMode ? BColors.black : Colors.white,
          indicatorColor: darkMode ? BColors.white.withOpacity(0.1) : BColors.black.withOpacity(0.1),

          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.shop), label: 'Store'),
            NavigationDestination(icon: Icon(Iconsax.reserve), label: 'Reservasi'),
            NavigationDestination(icon: Icon(Iconsax.heart), label: 'WishList' ),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ]
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [ const HomeScreen(), const StoreScreen(), const ReservationScreen(), const FavoriteScreen(), const SettingsScreen()
  ];
}