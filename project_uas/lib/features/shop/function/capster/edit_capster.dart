import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

void showEditCapsterSheet(BuildContext context) async {
  final snapshot = await FirebaseFirestore.instance.collection('Layanan').get();

  if (snapshot.docs.isEmpty) {
    Get.snackbar("No Capster", "Belum ada data capster untuk diedit.");
    return;
  }

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pilih Capster untuk Diedit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                final capster = snapshot.docs[index];
                final data = capster.data();
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(data['ImageUrl'] ?? '')),
                  title: Text(data['Name'] ?? ''),
                  subtitle: Text(data['Phone'] ?? ''),
                  trailing: const Icon(Iconsax.edit),
                  onTap: () {
                    Navigator.of(context).pop();
                    showCapsterEditDialog(context, capster);
                  },
                );
              },
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

void showCapsterEditDialog(BuildContext context, DocumentSnapshot doc) async {
  final data = doc.data() as Map<String, dynamic>;
  final nameController = TextEditingController(text: data['Name']);
  final phoneController = TextEditingController(text: data['Phone']);
  final imageUrl = data['ImageUrl'];
  final List<dynamic> existingPackages = data['Packages'] ?? [];

  List<Map<String, dynamic>> selectedPackages = List<Map<String, dynamic>>.from(existingPackages);
  File? newImage;
  final picker = ImagePicker();
  bool isLoading = false;

  Get.dialog(
    StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: const Text("Edit Capster"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Capster Name",
                        floatingLabelStyle: TextStyle(
                          color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        floatingLabelStyle: TextStyle(
                          color: Theme.of(Get.context!).brightness == Brightness.dark ? Colors.white : Colors.black,
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
                            ...docs.map((pkg) {
                              final pkgData = pkg.data() as Map<String, dynamic>;
                              final isSelected = selectedPackages.any((p) => p['id'] == pkg.id);

                              return CheckboxListTile(
                                value: isSelected,
                                title: Text("${pkgData['Name']} - Rp ${pkgData['Price']}"),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      selectedPackages.add({
                                        'id': pkg.id,
                                        'name': pkgData['Name'],
                                        'price': pkgData['Price'],
                                      });
                                    } else {
                                      selectedPackages.removeWhere((p) => p['id'] == pkg.id);
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

                    /// Gambar capster
                    if (newImage != null)
                      Column(
                        children: [
                          Image.file(newImage!, height: 100),
                          Text(newImage!.path.split('/').last),
                          TextButton.icon(
                            onPressed: () => setState(() => newImage = null),
                            icon: const Icon(Icons.close),
                            label: const Text("Remove Image"),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                          ),
                        ],
                      )
                    else if (imageUrl != null)
                      Column(
                        children: [
                          Image.network(imageUrl, height: 100),
                          TextButton.icon(
                            onPressed: () => setState(() => newImage = null),
                            icon: const Icon(Icons.image),
                            label: const Text("Change Image"),
                          ),
                        ],
                      )
                    else
                      ElevatedButton.icon(
                        icon: const Icon(Icons.image),
                        label: const Text("Select Profile Image"),
                        onPressed: () async {
                          final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
                          if (picked != null) {
                            setState(() => newImage = File(picked.path));
                          }
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final phone = phoneController.text.trim();

                    if (name.isEmpty || phone.isEmpty || selectedPackages.isEmpty) {
                      Get.snackbar("Error", "Please complete all fields",
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }

                    setState(() => isLoading = true);

                    try {
                      String? newImageUrl = imageUrl;
                      if (newImage != null) {
                        final ref = FirebaseStorage.instance
                            .ref().child('Capsters/${DateTime.now().millisecondsSinceEpoch}.jpg');
                        await ref.putFile(newImage!);
                        newImageUrl = await ref.getDownloadURL();
                      }

                      await FirebaseFirestore.instance.collection('Layanan').doc(doc.id).update({
                        'Name': name,
                        'Phone': phone,
                        'ImageUrl': newImageUrl,
                        'Packages': selectedPackages,
                      });

                      Get.back();
                      Get.snackbar("Success", "Capster updated successfully",
                          backgroundColor: Colors.green, colorText: Colors.white);
                    } catch (e) {
                      Get.snackbar("Error", "Failed to update: $e",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    } finally {
                      setState(() => isLoading = false);
                    }
                  },
                  child: const Text("Save Changes"),
                ),
              ],
            ),

            /// Overlay loading
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