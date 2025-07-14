import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Fungsi untuk ambil data dan tampilkan BottomSheet
void fetchAndShowDeletePackageSheet(BuildContext context) async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('Package').get();
    final docs = snapshot.docs;

    showDeletePackageSheet(context, docs);
  } catch (e) {
    Get.snackbar("Error", "Gagal mengambil data paket: $e");
  }
}

/// Fungsi untuk menampilkan BottomSheet (hanya dipanggil jika data sudah ada)
void showDeletePackageSheet(BuildContext context, List<QueryDocumentSnapshot> docs) {

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    isScrollControlled: true,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: docs.isEmpty
            ? const Center(child: Text("No Package Available"))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [                 
                  const Text(
                    "Delete Package",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final name = doc['Name'];
                      final price = doc['Price'];

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const Icon(Icons.local_offer_rounded, color: Colors.blue),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text("Rp $price"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
                            onPressed: () async {
                              final confirm = await Get.dialog(AlertDialog(
                                title: const Text("Konfirmasi"),
                                content: Text("Yakin ingin menghapus paket '$name'?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(result: false),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Get.back(result: true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ));

                              if (confirm == true) {
                                await FirebaseFirestore.instance.collection('Package').doc(doc.id).delete();
                                Get.snackbar("Berhasil", "Paket '$name' telah dihapus");
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      );
    },
  );
}
