import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadCapsterDialog {
  static void show(BuildContext context) {
    final TextEditingController capsterNameController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey[600] : Colors.grey[300];

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text("Upload Capster"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: capsterNameController,
                decoration: InputDecoration(
                  labelText: "Capster Name",
                  hintText: "Enter Capster Name",
                  floatingLabelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload_rounded),
                  label: const Text("Upload"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final name = capsterNameController.text.trim();
                    if (name.isEmpty) {
                      Get.snackbar(
                        "Failed",
                        "Capster Name Shouldn't Empty!.",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    await FirebaseFirestore.instance
                        .collection('kapster')
                        .add({"Name": name});

                    Get.back();
                    Get.snackbar(
                      "Success",
                      "Capster Successfully Have been Uploded!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
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
