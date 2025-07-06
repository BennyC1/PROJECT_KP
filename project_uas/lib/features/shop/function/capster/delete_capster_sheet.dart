import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showDeleteCapsterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return FutureBuilder(
        future: FirebaseFirestore.instance.collection('kapster').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final docs = snapshot.data!.docs;

          return ListView(
            children: docs.map((doc) {
              final name = doc['Name'];
              return ListTile(
                title: Text(name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('kapster').doc(doc.id).delete();
                    Get.snackbar("Deleted", "$name berhasil dihapus");
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          );
        },
      );
    },
  );
}
