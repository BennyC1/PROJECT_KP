import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadCapsterDialog {
  static void show() {
    final TextEditingController capsterNameController = TextEditingController();

    Get.defaultDialog(
      title: "Upload Capster",
      content: Column(
        children: [
          TextField(
            controller: capsterNameController,
            decoration: const InputDecoration(labelText: "Capster Name"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final name = capsterNameController.text.trim();
              if (name.isNotEmpty) {
                await FirebaseFirestore.instance.collection('kapster').add({"Name": name});
                Get.back();
                Get.snackbar("Success", "Capster berhasil diupload");
              }
            },
            child: const Text("Upload"),
          )
        ],
      ),
    );
  }
}