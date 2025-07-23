// capster_package_actions.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';

void showDeleteCapsterPackageSheet() {
  final context = Get.context!;
  final theme = Theme.of(context);

  Get.bottomSheet(
    FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('CapsterPackage').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;

        return Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Hapus CapsterPackage", style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['capsterName'] ?? '-', style: theme.textTheme.bodyLarge),
                  subtitle: Text("Total Paket: ${data['packages']?.length ?? 0}",
                      style: theme.textTheme.bodySmall),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('CapsterPackage').doc(doc.id).delete();
                      Get.back();
                      Get.snackbar("Success", "CapsterPackage dihapus",
                          backgroundColor: Colors.green, colorText: Colors.white);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    ),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}

void showEditCapsterPackageSheet() {
  final context = Get.context!;
  final theme = Theme.of(context);

  Get.bottomSheet(
    FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('CapsterPackage').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;

        return Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text("Edit CapsterPackage", style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['capsterName'] ?? '-', style: theme.textTheme.bodyLarge),
                  subtitle: Text("Total Paket: ${data['packages']?.length ?? 0}",
                      style: theme.textTheme.bodySmall),
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
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}

void showEditCapsterPackageDialog(String docId, Map<String, dynamic> oldData) {
  final context = Get.context!;
  final theme = Theme.of(context);
  final selectedPackages = List<Map<String, dynamic>>.from(oldData['packages'] ?? []);
  final capsterName = oldData['capsterName'] ?? '-';

  Get.dialog(
    StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Edit CapsterPackage', style: theme.textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Capster: $capsterName", style: theme.textTheme.bodyMedium),
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
                          title: Text("${data['Name']} - Rp ${data['Price']}",
                              style: theme.textTheme.bodyMedium),
                          controlAffinity: ListTileControlAffinity.leading,
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
                Get.snackbar('Success', 'Data berhasil diperbarui',
                    backgroundColor: Colors.green, colorText: Colors.white);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    ),
  );
}
