import 'package:get/get.dart';
import 'package:project_uas/data/product/product_repository.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class SearchControllerProduct extends GetxController {
  static SearchControllerProduct get instance => Get.find();

  final productRepository = Get.put(ProductRepository());

  final isLoading = false.obs;
  final allProducts = <ProductModel>[].obs;
  final searchResults = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  /// Fetch semua produk untuk pencarian
  Future<void> fetchAllProducts() async {
    try {
      isLoading.value = true;
      final products = await productRepository.getAllFeaturedProducts(); 
      allProducts.assignAll(products);
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Jalankan pencarian
  void search(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    final results = allProducts.where((product) {
      final titleMatch = product.title.toLowerCase().contains(query.toLowerCase());
      final brandMatch = product.brand?.name.toLowerCase().contains(query.toLowerCase()) ?? false;
      return titleMatch || brandMatch;
    }).toList();

    searchResults.assignAll(results);
  }

  /// Reset hasil pencarian
  void clearSearch() {
    searchResults.clear();
  }
}
