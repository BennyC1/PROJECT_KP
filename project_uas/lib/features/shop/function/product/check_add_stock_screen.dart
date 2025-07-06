import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas/features/shop/models/product_model.dart';

class CheckAddStockScreen extends StatelessWidget {
  const CheckAddStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek & Tambah Stok Produk"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Products').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Tidak ada produk ditemukan."));
          }

          final products = snapshot.data!.docs
              .map((doc) => ProductModel.fromQuerySnapshotWithoutBrand(doc))
              .toList();

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              final TextEditingController addController = TextEditingController();

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.thumbnail,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Detail & Form
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black,
                                )),
                            const SizedBox(height: 6),
                            Text("Stok saat ini: ${product.stock}",
                                style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.black54)),
                            const SizedBox(height: 8),

                            // Input & Button
                            Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: TextField(
                                    controller: addController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '+Jumlah',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                      border: const OutlineInputBorder(),
                                      hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
                                    ),
                                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
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
                                    } else {
                                      Get.snackbar("Error", "Masukkan jumlah valid");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  child: const Text("Tambah"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
