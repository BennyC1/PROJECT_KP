import 'package:get/get.dart';
import 'package:project_uas/features/shop/controllers/product/checkout_controller.dart';
import 'package:project_uas/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(CheckoutController());
  }
}