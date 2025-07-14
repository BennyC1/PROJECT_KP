import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas/features/shop/models/product_model.dart';

class CheckAddStockScreen extends StatefulWidget {
  const CheckAddStockScreen({super.key});

  @override
  State<CheckAddStockScreen> createState() => _CheckAddStockScreenState();
}

class _CheckAddStockScreenState extends State<CheckAddStockScreen> {
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
    final snapshot = await FirebaseFirestore.instance.collection('Products').get();
    final products = snapshot.docs.map((doc) => ProductModel.fromQuerySnapshotWithoutBrand(doc)).toList();
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
      appBar: AppBar(
        title: const Text("Cek & Tambah Stok Produk"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Product Name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Produk List
            Expanded(
              child: Obx(() {
                if (_filteredProducts.isEmpty) {
                  return const Center(child: Text("Tidak Ada Produk Ditemukan."));
                }

                return ListView.separated(
                  itemCount: _filteredProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    final TextEditingController addController = TextEditingController();

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.thumbnail,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                ),
                              ),
                              title: Text(product.title,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      )),
                              subtitle: Text("Stok saat ini: ${product.stock}"),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: TextField(
                                    controller: addController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '+Jumlah',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final addValue = int.tryParse(addController.text.trim());
                                    if (addValue != null && addValue > 0) {
                                      final newStock = product.stock + addValue;
                                      await FirebaseFirestore.instance
                                          .collection('Products')
                                          .doc(product.id)
                                          .update({'Stock': newStock});

                                      Get.snackbar("Berhasil", "Stok '${product.title}' ditambah $addValue");
                                      addController.clear();
                                      _loadProducts(); // refresh list
                                    } else {
                                      Get.snackbar("Error", "Masukkan jumlah valid");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  icon: const Icon(Icons.add),
                                  label: const Text("Tambah"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
