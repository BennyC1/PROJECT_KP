import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UploadCapsterPackageDialog {
  static void show(BuildContext context) {
    String? selectedCapsterId;
    String? selectedCapsterName;
    List<Map<String, dynamic>> selectedPackages = [];
    bool isLoading = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
              AlertDialog(
                title: const Text('Upload CapsterPackage'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Dropdown Capster
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance.collection('Capster').get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const CircularProgressIndicator();
                          final docs = snapshot.data!.docs;
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: 'Select Capster'),
                            value: selectedCapsterId,
                            items: docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return DropdownMenuItem<String>(
                                value: doc.id,
                                child: Text(data['Name']),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCapsterId = val;
                                selectedCapsterName = docs
                                    .firstWhere((doc) => doc.id == val)
                                    .get('Name');
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      /// Checkbox Packages
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance.collection('Package').get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const CircularProgressIndicator();
                          final docs = snapshot.data!.docs;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Select Packages"),
                              const SizedBox(height: 6),
                              ...docs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final isSelected = selectedPackages.any((pkg) => pkg['id'] == doc.id);

                                return CheckboxListTile(
                                  value: isSelected,
                                  title: Text("${data['Name']} - Rp ${data['Price']}"),
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        selectedPackages.add({
                                          'id': doc.id,
                                          'name': data['Name'],
                                          'price': data['Price'],
                                        });
                                      } else {
                                        selectedPackages.removeWhere((pkg) => pkg['id'] == doc.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("Save"),
                        onPressed: () async {
                          if (selectedCapsterId == null || selectedPackages.isEmpty) {
                            Get.snackbar("Error", "Please select capster and at least 1 package.",
                                backgroundColor: Colors.red, colorText: Colors.white);
                            return;
                          }

                          setState(() => isLoading = true);
                          try {
                            await FirebaseFirestore.instance.collection('CapsterPackage').add({
                              'capsterId': selectedCapsterId,
                              'capsterName': selectedCapsterName,
                              'packages': selectedPackages,
                              'createdAt': FieldValue.serverTimestamp(),
                            });
                            Get.back();
                            Get.snackbar("Success", "CapsterPackage uploaded!",
                                backgroundColor: Colors.green, colorText: Colors.white);
                          } catch (e) {
                            Get.snackbar("Error", "Failed to upload: $e",
                                backgroundColor: Colors.red, colorText: Colors.white);
                          } finally {
                            setState(() => isLoading = false);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                ),
            ],
          );
        },
      ),
    );
  }
}
