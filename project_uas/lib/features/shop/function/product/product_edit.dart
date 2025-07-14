import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/data/product/product_repository.dart';
import 'package:project_uas/features/shop/function/product/product_edit_form.dart';
import 'package:project_uas/features/shop/models/product_model.dart';

class ProductEditListScreen extends StatefulWidget {
  const ProductEditListScreen({super.key});

  @override
  State<ProductEditListScreen> createState() => _ProductEditListScreenState();
}

class _ProductEditListScreenState extends State<ProductEditListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RxList<ProductModel> _allProducts = <ProductModel>[].obs;
  final RxList<ProductModel> _filteredProducts = <ProductModel>[].obs;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadProducts() async {
    final products = await ProductRepository.instance.getFeaturedProducts();
    _allProducts.assignAll(products);
    _filteredProducts.assignAll(products);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    _filteredProducts.assignAll(
      _allProducts.where((product) => product.title.toLowerCase().contains(query)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Product to Edit', style: Theme.of(context).textTheme.headlineMedium)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Product By Name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Product List
            Expanded(
              child: Obx(() {
                if (_filteredProducts.isEmpty) {
                  return const Center(child: Text('No Products Found'));
                }

                return ListView.builder(
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return ListTile(
                      leading: Image.network(product.thumbnail, width: 40, height: 40, fit: BoxFit.cover),
                      title: Text(product.title),
                      subtitle: Text('Rp ${product.price}'),
                      onTap: () => Get.to(() => ProductEditFormScreen(product: product)),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
