import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/data/product/product_repository.dart';
import 'package:project_uas/features/shop/models/product_model.dart';

void showDeleteProductSheet(BuildContext context) async {
  final allProducts = await ProductRepository.instance.getAllFeaturedProducts();
  final RxList<ProductModel> filteredProducts = allProducts.obs;
  final searchController = TextEditingController();

  // Listener untuk search
  searchController.addListener(() {
    final query = searchController.text.toLowerCase();
    filteredProducts.assignAll(allProducts.where((product) =>
        product.title.toLowerCase().contains(query)));
  });

  Get.bottomSheet(
    SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Judul
            Text(
              'Delete Product',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Product...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Daftar Produk
            Expanded(
              child: Obx(() {
                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('No Product Found!'));
                }

                return ListView.separated(
                  itemCount: filteredProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return Row(
                      children: [
                        // Gambar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.thumbnail,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Nama Produk
                        Expanded(
                          child: Text(product.title,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),

                        // Tombol Delete
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await Get.defaultDialog<bool>(
                              title: 'Hapus Produk?',
                              middleText: 'Yakin ingin menghapus produk ini?',
                              confirm: ElevatedButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text('Ya'),
                              ),
                              cancel: OutlinedButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('Tidak'),
                              ),
                            );
                            if (confirm == true) {
                              await ProductRepository.instance.deleteProductById(product.id);
                              allProducts.removeWhere((p) => p.id == product.id);
                              filteredProducts.remove(product);
                              Get.snackbar('Berhasil', 'Produk berhasil dihapus');
                            }
                          },
                        )
                      ],
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 20),

            // Tombol Hapus Semua Produk
            ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever),
              label: const Text('Hapus Semua Produk'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () async {
                final confirm = await Get.defaultDialog<bool>(
                  title: 'Hapus Semua Produk?',
                  middleText: 'Yakin ingin menghapus semua produk?',
                  confirm: ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text('Ya'),
                  ),
                  cancel: OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text('Tidak'),
                  ),
                );

                if (confirm == true) {
                  await ProductRepository.instance.deleteAllProducts();
                  allProducts.clear();
                  filteredProducts.clear();
                  Get.back(); // Tutup bottomSheet
                  Get.snackbar('Berhasil', 'Semua produk berhasil dihapus');
                }
              },
            )
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
