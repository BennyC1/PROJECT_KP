import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_uas/data/product/product_repository.dart';
import 'package:project_uas/features/shop/models/brand_model.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/features/shop/models/product_variation_model.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class ProductUploadForm extends StatefulWidget {
  const ProductUploadForm({super.key});

  @override
  State<ProductUploadForm> createState() => _ProductUploadFormState();
}

class _ProductUploadFormState extends State<ProductUploadForm> {
  List<String> selectedBrandIds = []; 
  List<String> selectedCategoryIds = []; 
  List<QueryDocumentSnapshot<Map<String, dynamic>>> brandDocs = [];
  String? selectedBrandId;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  void _loadBrands() async {
    final snapshot = await FirebaseFirestore.instance.collection('Brands').get();
    setState(() {
      brandDocs = snapshot.docs;
    });
  }

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _brandIdController = TextEditingController();
  final _brandNameController = TextEditingController();
  final _brandImageUrlController = TextEditingController();
  bool isBrandFeatured = true;


  bool isFeatured = true;
  String selectedBrandName = 'Cultusia';
  String selectedCategoryId = '101';

  List<XFile> productImages = [];
  List<XFile> variationImages = [];
  XFile? thumbnailImage;

  Future<void> _pickMultipleImages(List<XFile> targetList) async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        targetList.clear();
        targetList.addAll(picked);
      });
    }
  }

  Future<void> _pickThumbnail() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => thumbnailImage = picked);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (thumbnailImage == null ) {
      BLoaders.errorSnackBar(title: 'Gagal', message: 'Thumbnail wajib diisi!');
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final productRepo = Get.put(ProductRepository());

      final brandMap = {
        'Id': _brandIdController.text.trim(),
        'Name': _brandNameController.text.trim(),
        'Image': _brandImageUrlController.text.trim(),
        'IsFeatured': isBrandFeatured,
        'ProductsCount': 0, 
      };

      final imageListPath = productImages.map((img) => img.path).toList();
      final variations = variationImages.asMap().entries.map((entry) {
        final index = entry.key;
        final image = entry.value;
        return ProductVariationModel(
          id: (2001 + index).toString(),
          image: image.path,
        );
      }).toList();

      final newProduct = ProductModel(
        id: 'temp',
        title: _titleController.text,
        stock: int.parse(_stockController.text),
        price: double.parse(_priceController.text),
        salePrice: double.parse(_salePriceController.text),
        thumbnail: thumbnailImage!.path,
        productType: 'ProductType.single',
        description: _descriptionController.text,
        descriptiontitle: _shortDescController.text,
        images: imageListPath,
        brand: BrandModel.fromJson(brandMap),
        categoryId: selectedCategoryId,
        isFeatured: isFeatured,
        sku: _skuController.text,
        productVariations: variations,
      );

      await productRepo.uploadProduct(newProduct);
      // Simpan relasi kategori
      for (final categoryId in selectedCategoryIds) {
        await FirebaseFirestore.instance.collection('ProductCategory').add({
          'productId': newProduct.id,
          'categoryId': categoryId,
        });
      }

      // Simpan relasi brand
      for (final brandId in selectedBrandIds) {
        await FirebaseFirestore.instance.collection('BrandCategory').add({
          'productId': newProduct.id,
          'brandId': brandId,
        });
      }
      Get.back();
      BLoaders.successSnackBar(title: 'Sukses', message: 'Produk berhasil diunggah.');
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Gagal', message: e.toString());
    }
  }

  Future<Map<String, dynamic>?> getBrandMapByName(String brandName) async {
    final brandsSnapshot = await FirebaseFirestore.instance.collection('Brands').get();
    for (var doc in brandsSnapshot.docs) {
      if ((doc.data()['Name'] ?? '').toString().toLowerCase() == brandName.toLowerCase()) {
        return {
          'Id': doc.id,
          'Image': doc.data()['Image'],
          'IsFeatured': doc.data()['IsFeatured'],
          'Name': doc.data()['Name'],
          'ProductsCount': doc.data()['ProductsCount'] ?? 0,
        };
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            Text(
              '🧾 Data Brand',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedBrandId,
              items: brandDocs.map((doc) {
                final id = doc.id;
                final name = doc['Name'] ?? '';
                return DropdownMenuItem(
                  value: id,
                  child: Text('$id - $name'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBrandId = value;
                  _brandIdController.text = value ?? '';

                  final brand = brandDocs.firstWhere((doc) => doc.id == value);
                  _brandNameController.text = brand['Name'] ?? '';
                  _brandImageUrlController.text = brand['Image'] ?? '';
                  isBrandFeatured = brand['IsFeatured'] ?? false;
                });
              },
              decoration: InputDecoration(
                labelText: 'Brand ID (Pilih dari daftar)', 
                floatingLabelStyle: TextStyle(
                  color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                )),
              validator: (v) => v == null || v.isEmpty ? 'Wajib pilih Brand' : null,
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _brandNameController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Brand Name', 
                floatingLabelStyle: TextStyle(
                  color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                )),
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _brandImageUrlController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Brand Image URL', 
                floatingLabelStyle: TextStyle(
                  color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                )),
            ),
            const SizedBox(height: 10),

            SwitchListTile(
              title: Text(
                'Brand Featured?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: isBrandFeatured,
              onChanged: (v) => setState(() => isBrandFeatured = v),
            ),
            const SizedBox(height: 16),

            Text(
              '📝 Informasi Produk',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul Produk',
                floatingLabelStyle: TextStyle(
                  color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _shortDescController,
              decoration: InputDecoration(
                labelText: 'Deskripsi Singkat',
                floatingLabelStyle: TextStyle(
                  color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi Lengkap',
                floatingLabelStyle: TextStyle(
                  color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _skuController,
              decoration: InputDecoration(
                labelText: 'SKU',
                floatingLabelStyle: TextStyle(
                  color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Harga',
                      floatingLabelStyle: TextStyle(
                        color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _salePriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Harga Diskon',
                      floatingLabelStyle: TextStyle(
                        color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Stok',
                floatingLabelStyle: TextStyle(
                  color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: Text(
                'Tampilkan di Beranda?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: isFeatured,
              onChanged: (v) => setState(() => isFeatured = v),
            ),

            const SizedBox(height: 16),
            const Text('Kategori Produk', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('Categories').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final docs = snapshot.data!.docs;

                // Pisahkan parent dan child
                final parentCategories = docs.where((doc) {
                  final parentId = doc['ParentId'];
                  return parentId == null || parentId.toString().isEmpty;
                }).toList();

                final childCategories = docs.where((doc) {
                  final parentId = doc['ParentId'];
                  return parentId != null && parentId.toString().isNotEmpty;
                }).toList();

                // Kelompokkan anak-anak berdasarkan ParentId
                Map<String, List<QueryDocumentSnapshot>> groupedChildren = {};
                for (var child in childCategories) {
                  final parentId = child['ParentId'];
                  groupedChildren.putIfAbsent(parentId, () => []).add(child);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: parentCategories.map((parent) {
                    final parentId = parent.id;
                    final parentName = parent['Name'] ?? 'Kategori Utama';

                    final children = groupedChildren[parentId] ?? [];

                    return ExpansionTile(
                      title: Text('🗂️ $parentName', style: const TextStyle(fontWeight: FontWeight.bold)),
                      children: children.map((child) {
                        final childId = child.id;
                        final childName = child['Name'] ?? 'Tanpa Nama';

                        return CheckboxListTile(
                          title: Text(childName),
                          value: selectedCategoryIds.contains(childId),
                          onChanged: (val) {
                            setState(() {
                              val == true
                                  ? selectedCategoryIds.add(childId)
                                  : selectedCategoryIds.remove(childId);
                            });
                          },
                        );
                      }).toList(),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 16),
            const Text('Brand Produk', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('Brands').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return Column(
                  children: docs.map((doc) {
                    final id = doc.id;
                    final name = doc['Name'] ?? 'Tanpa Nama';
                    return CheckboxListTile(
                      title: Text(name),
                      value: selectedBrandIds.contains(id),
                      onChanged: (val) {
                        setState(() {
                          val == true ? selectedBrandIds.add(id) : selectedBrandIds.remove(id);
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),

            /// --- SECTION: GAMBAR ---
            const Divider(height: 40),
            const Text('🖼️ Gambar Produk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Thumbnail
            GestureDetector(
              onTap: _pickThumbnail,
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: thumbnailImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(File(thumbnailImage!.path), height: 120, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Tap to upload thumbnail image', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Gambar Variasi
            GestureDetector(
              onTap: () => _pickMultipleImages(variationImages),
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: variationImages.isNotEmpty
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: variationImages.map((img) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(File(img.path), height: 120),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.layers_outlined, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Tap to upload variation images', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            /// --- SUBMIT BUTTON ---
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Upload Produk', style: TextStyle(fontSize: 16)),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


