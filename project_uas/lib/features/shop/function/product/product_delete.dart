import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/data/product/product_repository.dart';

void showDeleteProductSheet(BuildContext context) async {
  final productList = await ProductRepository.instance.getAllFeaturedProducts(); // Atau buat method getAllProducts()

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
            Text(
              'Daftar Produk',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// Product ListView
            SizedBox(
              height: 300,
              child: productList.isEmpty
                  ? const Center(child: Text('Tidak ada produk.'))
                  : ListView.separated(
                      itemCount: productList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final product = productList[index];
                        return Row(
                          children: [
                            /// Gambar Produk
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

                            /// Nama Produk
                            Expanded(
                              child: Text(product.title, style: Theme.of(context).textTheme.bodyMedium),
                            ),

                            /// Tombol Delete
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
                                  Get.back(); // Tutup sheet
                                  Get.snackbar('Berhasil', 'Produk berhasil dihapus');
                                }
                              },
                            )
                          ],
                        );
                      },
                    ),
            ),

            const SizedBox(height: 20),

            /// Tombol Hapus Semua Produk
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
                  Get.back();
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
