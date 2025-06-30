import 'package:get/get.dart';

import '../../personalization/screens/settings/settings.dart';
import '../screens/home/home.dart';
import '../screens/reservation/reservation.dart';
import '../screens/store/store.dart';
import '../screens/wishlist/wishlist.dart';

class NavigationController extends GetxController {
  int selectedIndex = 0;

  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    const ReservationScreen(),
    const FavoriteScreen(),
    const SettingsScreen(),
  ];

  void changeTab(int index) {
    selectedIndex = index;
    update(); // trigger rebuild
  }
}
