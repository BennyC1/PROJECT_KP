// capster_package_actions.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';

void showDeleteCapsterPackageSheet() {
  Get.bottomSheet(
    FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('CapsterPackage').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Hapus CapsterPackage", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['capsterName'] ?? '-'),
                  subtitle: Text("Total Paket: ${data['packages']?.length ?? 0}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('CapsterPackage').doc(doc.id).delete();
                      Get.back();
                      Get.snackbar("Success", "CapsterPackage dihapus", backgroundColor: Colors.green, colorText: Colors.white);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}

void showEditCapsterPackageSheet() {
  Get.bottomSheet(
    FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('CapsterPackage').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text("Edit CapsterPackage", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['capsterName'] ?? '-'),
                  subtitle: Text("Total Paket: ${data['packages']?.length ?? 0}"),
                  trailing: const Icon(Iconsax.edit),
                  onTap: () {
                    Get.back();
                    showEditCapsterPackageDialog(doc.id, data);
                  },
                );
              }),
            ],
          ),
        );
      },
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}

void showEditCapsterPackageDialog(String docId, Map<String, dynamic> oldData) {
  final selectedPackages = List<Map<String, dynamic>>.from(oldData['packages'] ?? []);
  final capsterName = oldData['capsterName'] ?? '-';

  Get.dialog(
    StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Edit CapsterPackage'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Capster: $capsterName"),
                const SizedBox(height: 12),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('Package').get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    final docs = snapshot.data!.docs;
                    return Column(
                      children: docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final isSelected = selectedPackages.any((p) => p['id'] == doc.id);
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
                                selectedPackages.removeWhere((p) => p['id'] == doc.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('CapsterPackage').doc(docId).update({
                  'packages': selectedPackages,
                });
                Get.back();
                Get.snackbar('Success', 'Data berhasil diperbarui', backgroundColor: Colors.green, colorText: Colors.white);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    ),
  );
}