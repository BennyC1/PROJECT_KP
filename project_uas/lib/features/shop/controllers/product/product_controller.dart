import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/data/product/product_repository.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/popups/loaders.dart';

import '../../models/product_model.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get. find();

  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchFeaturedProducts () ;
    super.onInit();
  }

  void fetchFeaturedProducts() async {
    try {
      // Show Loader while Loading Products
      isLoading. value = true;

      // Fetch Products
      final products = await productRepository.getFeaturedProducts();

      // Assign Products
      featuredProducts.assignAll(products);
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading. value = false;
    }
  }

  Future<List<ProductModel>> fetchAllFeaturedProducts() async {
    try {
      // Fetch Products
      final products = await productRepository.getFeaturedProducts();
      return products;
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    } 
  }

  // Get Product Price or price for variation
  String getProductPrice(ProductModel product) {
    if (product.productType != ProductType.single.toString()) {
      final formatted = NumberFormat.decimalPattern('id_ID').format(product.price);
      return '$formatted';
    }

    // Jika produk single, cek apakah ada harga diskon
    final priceToShow = (product.salePrice > 0) ? product.salePrice : product.price;

    // Format ke bentuk 1.000.000
    final formattedPrice = NumberFormat.decimalPattern('id_ID').format(priceToShow);
    return '$formattedPrice';
  
    // double smallestPrice = double.infinity;
    // double largestPrice = 0.0;

    // // If no variations exist, return the simple price or sale price
    // if(product.productType == ProductType.single.toString()){
    //   return (product.salePrice > 0 ? product.salePrice : product.price).toString();
    // } else {
      // Calculate the smallest and Largest prices among variations
      // for(var variation in product.productVariations?? []){
      //   // Determine the price to consider (sale price if available, otherwise regular price)
      //   double priceToConsider = variation. salePrice > 0.0 ? variation. salePrice : variation.price;

      //   // Update smallest and Largest prices
      //   if(priceToConsider < smallestPrice){
      //     smallestPrice = priceToConsider;
      //   }

      //   if (priceToConsider > largestPrice) {
      //     largestPrice = priceToConsider;
      //   }
      // }
      
      // If smallest and Largest prices are the same, return a single price
      // if (smallestPrice.isEqual(largestPrice)) {
      //   return largestPrice.toString();
      // } else {
      //   // Otherwise, return a price range
      //   return '$smallestPrice - \$$largestPrice' ;
      // }
    
  }

  /// -- Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// -- Check Product Stock Status
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }

}