import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadPackageDialog {
  static void show(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey[600] : Colors.grey[300];

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("Upload Package"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Package Name",
                  floatingLabelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Price",
                  prefixText: "Rp ",
                  floatingLabelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text("Upload Paket"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final price = int.tryParse(priceController.text) ?? 0;

                    if (name.isEmpty || price <= 0) {
                      Get.snackbar("Error", "Nama dan harga harus diisi dengan benar.",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }

                    await FirebaseFirestore.instance.collection('Package').add({
                      "Name": name,
                      "Price": price,
                    });

                    Get.back();
                    Get.snackbar("Berhasil", "Paket berhasil diupload",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
