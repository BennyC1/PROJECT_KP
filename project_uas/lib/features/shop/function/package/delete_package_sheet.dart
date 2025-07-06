import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showDeletePackageSheet(BuildContext context) {
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
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('Package').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Tidak ada paket yang tersedia."));
            }

            final docs = snapshot.data!.docs;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text(
                  "Hapus Paket",
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
                                  child: const Text("Batal"),
                                ),
                                ElevatedButton(
                                  onPressed: () => Get.back(result: true),
                                  child: const Text("Hapus"),
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
            );
          },
        ),
      );
    },
  );
}
