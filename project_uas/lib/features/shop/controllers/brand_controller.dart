import 'package:get/get.dart';
import 'package:project_uas/data/brand/brand_repository.dart';
import 'package:project_uas/data/product/product_repository.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/popups/loaders.dart';

import '../models/brand_model.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  RxBool isLoading = true.obs;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());

  @override
  void onInit() {
    getFeaturedBrands();
    super.onInit();
  }
  
  /// -- Load Brands
  Future<void> getFeaturedBrands() async {
    try {
      
      // Show Loader while Loading Brands
      isLoading.value = true;

      final brands = await brandRepository.getAllBrands();

      allBrands.assignAll(brands);

      featuredBrands.assignAll(allBrands.where((brand) => brand.isFeatured ?? false).take(4));

    } catch (e) {
      BLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Stop Loader
      isLoading.value = false;
    }
  }

  // get brand for category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      final brands = await brandRepository.getBrandsForCategory(categoryId);
      return brands;
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Oh Snap!', message: e. toString());
      return [];
    }
  }

  // Get brand product
  Future<List<ProductModel>> getBrandProducts({required String brandId, int limit = -1}) async {
    try {
      final products = await ProductRepository.instance.getProductsForBrand(brandId: brandId, limit: limit);
      return products;
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }
}
