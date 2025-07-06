import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadPackageDialog {
  static void show() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    Get.defaultDialog(
      title: "Upload Package",
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Package Name"),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Price"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final price = int.tryParse(priceController.text) ?? 0;
              if (name.isNotEmpty && price > 0) {
                await FirebaseFirestore.instance.collection('Package').add({"Name": name, "Price": price});
                Get.back();
                Get.snackbar("Success", "Paket berhasil diupload");
              }
            },
            child: const Text("Upload"),
          )
        ],
      ),
    );
  }
}