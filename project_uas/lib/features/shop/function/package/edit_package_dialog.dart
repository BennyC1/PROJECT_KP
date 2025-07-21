import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditPackageDialog {
  static void show(BuildContext context, String packageId) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey[600] : Colors.grey[300];

    Get.dialog(
      FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Package').doc(packageId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const AlertDialog(
              content: Center(child: CircularProgressIndicator()),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          nameController.text = data['Name'];
          priceController.text = data['Price'].toString();

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text("Edit Package"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Package Name",
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
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
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
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
                    icon: const Icon(Icons.save),
                    label: const Text("Save Changes"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final newName = nameController.text.trim();
                      final newPrice = int.tryParse(priceController.text.trim());

                      if (newName.isEmpty || newPrice == null) {
                        Get.snackbar("Failed", "Name and price must be valid",
                            backgroundColor: Colors.red, colorText: Colors.white);
                        return;
                      }

                      try {
                        await FirebaseFirestore.instance.collection('Package').doc(packageId).update({
                          'Name': newName,
                          'Price': newPrice,
                        });

                        Get.back();
                        Get.snackbar("Success", "Package updated successfully",
                            backgroundColor: Colors.green, colorText: Colors.white);
                      } catch (e) {
                        Get.snackbar("Error", "Failed to update package: $e",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
