import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UploadCapsterDialog {
  static void show(BuildContext context) {
    final TextEditingController capsterNameController = TextEditingController();
    final TextEditingController capsterPhoneController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey[600] : Colors.grey[300];

    List<Map<String, dynamic>> selectedPackages = [];
    File? selectedImage;
    final picker = ImagePicker();
    bool isLoading = false;

    Future<void> pickImage(Function setState) async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
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
                        controller: capsterPhoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Capster Phone",
                          floatingLabelStyle: TextStyle(
                            color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: borderColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                      const SizedBox(height: 12),

                      /// Image picker section
                      selectedImage == null
                          ? ElevatedButton.icon(
                              icon: const Icon(Icons.upload_file),
                              label: const Text("Input Profile Image"),
                              onPressed: () => pickImage(setState),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            )
                          : Column(
                              children: [
                                Image.file(selectedImage!, height: 120),
                                const SizedBox(height: 8),
                                Text(selectedImage!.path.split('/').last),
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      selectedImage = null;
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text("Remove Image"),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                ),
                              ],
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
                            final phone = capsterPhoneController.text.trim();

                            if (name.isEmpty || phone.isEmpty || selectedPackages.isEmpty || selectedImage == null) {
                              Get.snackbar("Failed", "Please fill all fields and pick image!",
                                  backgroundColor: Colors.red, colorText: Colors.white);
                              return;
                            }

                            setState(() => isLoading = true);

                            try {
                              // Upload image to Firebase Storage
                              final String fileId = const Uuid().v4();
                              final ref = FirebaseStorage.instance.ref().child('Capsters/$fileId.jpg');
                              await ref.putFile(selectedImage!);
                              final imageUrl = await ref.getDownloadURL();

                              // Save to Firestore
                              await FirebaseFirestore.instance.collection('Capster').add({
                                "Name": name,
                                "Phone": phone,
                                "ImageUrl": imageUrl,
                                "Packages": selectedPackages,
                                "CreatedAt": FieldValue.serverTimestamp(),
                              });

                              Get.back(); // Close dialog
                              Get.snackbar("Success", "Capster successfully uploaded!",
                                  backgroundColor: Colors.green, colorText: Colors.white);
                            } catch (e) {
                              Get.snackbar("Error", "Upload failed: $e",
                                  backgroundColor: Colors.red, colorText: Colors.white);
                            } finally {
                              setState(() => isLoading = false);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Loading overlay
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
