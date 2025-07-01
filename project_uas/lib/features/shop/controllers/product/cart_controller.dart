import 'package:get/get.dart';
import 'package:project_uas/features/shop/models/cart_item_model.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/local_storage/storage_utility.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  // Variables
  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  CartController(){
    loadCartItems();
  }

  // Add items in the cart
  void addToCart(ProductModel product) {
    // Quantity Check
    if (productQuantityInCart.value < 1) {
      BLoaders.customToast(message: 'Select Quantity');
      return;
    }

  // Out of Stock Status
  if (product.productType == ProductType.variable.toString()) {
    if (product.stock < 1) {
      BLoaders.warningSnackBar(message: 'Selected Product is out of stock.', title: 'Oh Snap!');
      return;
    }
  }

  // Convert the ProductModel to a CartItemModel with the given quantity
  final selectedCartItem = convertToCartItem(product, productQuantityInCart.value);

  // Check if already added in the Cart
  int index = cartItems
      .indexWhere((cartItem) => cartItem.productId == selectedCartItem.productId);

  if (index >= 0) {
    // This quantity is already added or Updated/Removed from the design (Cart)
    cartItems[index].quantity = selectedCartItem.quantity;
  } else {
    cartItems.add(selectedCartItem);
  }

  updateCart();
  BLoaders.customToast(message: 'Your Product has been added to the Cart.');
}

void addOneToCart(CartItemModel item) {
  int index = cartItems.indexWhere((cartItem) =>
      cartItem.productId == item.productId);

  if (index >= 0) {
    cartItems[index].quantity += 1;
  } else {
    cartItems.add(item);
  }

  updateCart();
}

void removeOneFromCart(CartItemModel item) {
  int index = cartItems.indexWhere((cartItem) =>
      cartItem.productId == item.productId);

  if (index >= 0) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity -= 1;
    } else {
      // Show dialog before completely removing
      cartItems[index].quantity == 1 ? removeFromCartDialog(index) : cartItems.removeAt(index);
    }

  updateCart();
  }
}

void removeFromCartDialog(int index) {
  Get.defaultDialog(
    title: 'Remove Product',
    middleText: 'Are you sure you want to remove this product?',
    onConfirm: () {
      // Remove the item from the cart
      cartItems.removeAt(index);
      updateCart();
      BLoaders.customToast(message: 'Product removed from the Cart.');
      Get.back();
    },
    onCancel: () => Get.back(),
  );
}

/// -- Initialize already added Item’s Count in the cart.
void updateAlreadyAddedProductCount(ProductModel product) {
  // If product has no variations then calculate cartEntries and display total number.
  // Else make default entries to 0 and show cartEntries when variation is selected.
  if (product.productType == ProductType.single.toString()) {
    productQuantityInCart.value = getProductQuantityInCart(product.id);
  } else {
      productQuantityInCart.value = 0;
    }
  }


/// This function converts a ProductModel to a CartItemModel
CartItemModel convertToCartItem(ProductModel product, int quantity) {
  final price = 
       product.salePrice > 0.0
          ? product.salePrice
          : product.price;

  return CartItemModel(
    productId: product.id,
    title: product.title,
    price: price,
    quantity: quantity,
    image: product.thumbnail,
    brandName: product.brand != null ? product.brand!.name : '',
  );
}

  /// Update Cart Values
  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice += (item.price) * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItems.value = calculatedNoOfItems;
  }

  void saveCartItems() {
    final cartItemStrings = cartItems.map((item) => item.toJson()).toList();
    BLocalStorage.instance().writeData('cartItems', cartItemStrings);
  }

  void loadCartItems() {
    final cartItemStrings = BLocalStorage.instance().readData<List<dynamic>>('cartItems');
    if (cartItemStrings != null) {
      cartItems.assignAll(cartItemStrings.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)));
      updateCartTotals();
    }
  }

  int getProductQuantityInCart(String productId) {
    final foundItem = cartItems.where((item) => item.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);
    return foundItem;
  }

  int getVariationQuantityInCart(String productId, String variationId) {
    final foundItem = cartItems.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItemModel.empty(),
    );
    return foundItem.quantity;
  }

  void clearCart(){
    productQuantityInCart .value = 0;
    cartItems.clear();
    updateCart();
  }
}
