import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void showDeleteCapsterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return FutureBuilder(
        future: FirebaseFirestore.instance.collection('Layanan').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text("Tidak ada capster yang tersedia.")),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Pilih Capster untuk Dihapus",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data();
                      final name = data['Name'] ?? 'Tanpa Nama';
                      final phone = data['Phone'] ?? '';
                      final imageUrl = data['ImageUrl'];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                          child: imageUrl == null ? const Icon(Icons.person) : null,
                        ),
                        title: Text(name),
                        subtitle: Text(phone),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Konfirmasi Hapus"),
                                content: Text("Apakah Anda yakin ingin menghapus $name?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("Hapus"),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                // Hapus gambar dari Storage jika ada
                                if (imageUrl != null && imageUrl.toString().contains('firebase')) {
                                  final ref = FirebaseStorage.instance.refFromURL(imageUrl);
                                  await ref.delete();
                                }

                                // Hapus dokumen dari Firestore
                                await FirebaseFirestore.instance.collection('Layanan').doc(doc.id).delete();

                                Get.snackbar("Berhasil", "$name berhasil dihapus.",
                                    backgroundColor: Colors.green, colorText: Colors.white);
                                Navigator.pop(context); // Tutup bottomsheet
                              } catch (e) {
                                Get.snackbar("Error", "Gagal menghapus: $e",
                                    backgroundColor: Colors.red, colorText: Colors.white);
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
