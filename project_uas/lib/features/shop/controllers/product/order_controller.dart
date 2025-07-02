import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/success_screen/success_screen.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/data/order/order_repository.dart';
import 'package:project_uas/features/shop/controllers/product/cart_controller.dart';
import 'package:project_uas/features/shop/controllers/product/checkout_controller.dart';
import 'package:project_uas/features/shop/models/order_model.dart';
import 'package:project_uas/navigation_menu.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/popups/full_screen_loader.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  /// Variables
  final cartController = CartController.instance;
  // final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  /// Fetch user's order history
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    } catch (e) {
      BLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  Future<void> updateProductStockAfterOrder() async {
    try {
      final items = cartController.cartItems;

      for (var item in items) {
        final productDoc = await FirebaseFirestore.instance
            .collection('Products')
            .doc(item.productId)
            .get();

        if (productDoc.exists) {
          final currentStock = productDoc['Stock'] ?? 0;
          final updatedStock = currentStock - item.quantity;

          await FirebaseFirestore.instance
              .collection('Products')
              .doc(item.productId)
              .update({'Stock': updatedStock});
        }
      }
    } catch (e) {
      BLoaders.warningSnackBar(title: 'Stock Update Error', message: e.toString());
    }
  }


  /// Add methods for order processing
  void processOrder(double totalAmount) async {
    try {
      // Start Loader
      BFullScreenLoader.openLoadingDialog('Processing your order', BImages.pencilAnimation);

      // Get user authentication Id
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) return;
      
      // Add Details
      final order = OrderModel(
        // Generate a unique ID for the order
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        // address: addressController.selectedAddress.value,
        items: cartController.cartItems.toList(),
      );

      // Save the order to Firestore
      await orderRepository.saveOrder(order, userId);

      // Update stock
      await updateProductStockAfterOrder();

      // Update the cart status
      cartController.clearCart();

      // Show Success screen
      Get.off(() => SuccessScreen(
        image: BImages.orderCompletedAnimation,
        title: 'Order Success!',
        subTitle: 'Please take you item in the shop!',
        onPressed: () => Get. offAll(() => const NavigationMenu()),
      ));  
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  } 
}