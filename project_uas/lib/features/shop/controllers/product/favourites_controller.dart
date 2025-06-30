import 'dart:convert';

import 'package:get/get.dart';
import 'package:project_uas/data/product/product_repository.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/local_storage/storage_utility.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class FavouritesController extends GetxController {
  static FavouritesController get instance => Get.find();

  /// Variables
  final favorites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavorites();
  }

  // Method to initialize favorites by reading from storage
  void initFavorites() {
    final json = BLocalStorage.instance() .readData('favorites' );
    if (json != null) {
      final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(storedFavorites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavourite(String productId) {
    return favorites[productId] ?? false;
  }

  void toggleFavoriteProduct(String productId) {
    if(!favorites.containsKey(productId)){
      favorites[productId] = true;
      saveFavoritesToStorage();
      BLoaders.customToast(message: 'Product has been added to the Wishlist. ');
    } else {
      BLocalStorage.instance().removeData(productId) ;
      favorites.remove(productId);
      saveFavoritesToStorage();
      favorites.refresh();
      BLoaders.customToast(message: 'Product has been removed from the Wishlist. ');
    }
  }

  void saveFavoritesToStorage() {
    final encodedFavorites = json.encode(favorites);
    BLocalStorage.instance().saveData('favorites', encodedFavorites);
  }
  
  Future<List<ProductModel>> favoriteProducts() async {
    return await ProductRepository.instance.getFavouriteProducts(favorites.keys.toList());
  }
}