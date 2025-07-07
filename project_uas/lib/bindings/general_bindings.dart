import 'package:get/get.dart';
import 'package:project_uas/data/brand/brand_repository.dart';
import 'package:project_uas/data/reservation/pending_reservation_repository.dart';
import 'package:project_uas/data/reservation/reservation_repository.dart';
import 'package:project_uas/data/user/user_repository.dart';
import 'package:project_uas/features/shop/controllers/product/cart_controller.dart';
import 'package:project_uas/features/shop/controllers/product/checkout_controller.dart';
import 'package:project_uas/features/shop/controllers/product/order_controller.dart';
import 'package:project_uas/features/shop/controllers/reservation_controller.dart';
import 'package:project_uas/features/shop/controllers/theme_controller.dart';
import 'package:project_uas/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(CheckoutController());
    Get.put(CartController());
    Get.put(ThemeController());
    Get.put(UserRepository());
    Get.put(BrandRepository());
    Get.put(ReservationController());
    Get.put(OrderController());
    Get.put(ReservationRepository());
  }
}