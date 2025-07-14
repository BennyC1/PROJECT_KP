import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_uas/features/shop/models/brand_model.dart';
import 'package:project_uas/data/brand/brand_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadBrandDialog {
  static void show() {
    final nameController = TextEditingController();
    final isFeatured = true.obs;
    final Rx<File?> imageFile = Rx<File?>(null);

    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 16),
      title: 'Upload Brand',
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Nama Brand
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Brand Name',
                floatingLabelStyle: TextStyle(
                  color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Gambar Brand
            Obx(() => GestureDetector(
              onTap: () async {
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 75);
                if (picked != null) imageFile.value = File(picked.path);
              },
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: imageFile.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(imageFile.value!, height: 120, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Tap to upload brand image', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            )),
            const SizedBox(height: 16),

            // Featured Switch
            Obx(() => SwitchListTile(
              value: isFeatured.value,
              onChanged: (value) => isFeatured.value = value,
              title: const Text('Feature this brand?'),
              secondary: const Icon(Icons.star),
            )),
            const SizedBox(height: 16),

            // Tombol Upload
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Upload Brand'),
                onPressed: () async {
                  final name = nameController.text.trim();
                  final file = imageFile.value;

                  if (name.isEmpty || file == null) {
                    Get.snackbar('Error', 'Nama dan gambar tidak boleh kosong');
                    return;
                  }

                  // Tampilkan loading dialog
                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );

                  try {
                    final productCount = await BrandRepository.instance.getProductCountByBrand(name);

                    // Upload image
                    final ref = FirebaseStorage.instance.ref('Brands/$name.jpg');
                    await ref.putFile(file);
                    final imageUrl = await ref.getDownloadURL();

                    final brand = BrandModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      image: imageUrl,
                      isFeatured: isFeatured.value,
                      productsCount: productCount,
                    );

                    await BrandRepository.instance.uploadBrand(brand);

                    // Tutup loading
                    Get.back(); // close loading
                    Get.back(); // close dialog
                    Get.snackbar('Success', 'Brand berhasil diupload');
                  } catch (e) {
                    Get.back(); // close loading
                    Get.snackbar('Error', 'Upload gagal: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
      radius: 10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}
