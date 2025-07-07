import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminDeletionScreen extends StatelessWidget {
  const AdminDeletionScreen({super.key});

  // Ambil semua user dengan role admin
  Future<List<QueryDocumentSnapshot>> fetchAllAdmins() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('role', isEqualTo: 'admin')
        .get();

    return snapshot.docs;
  }

  // Fungsi menghapus admin
  Future<void> deleteAdminAccount(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).delete();
      Get.snackbar("Success", "Admin account has been deleted.");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete admin: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Admin Accounts"),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: fetchAllAdmins(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final admins = snapshot.data!;
          if (admins.isEmpty) {
            return const Center(child: Text("No admin accounts found."));
          }

          return ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              final admin = admins[index];
              final name = admin['FirstName'] ?? 'No Name';
              final email = admin['Email'] ?? 'No Email';

              return ListTile(
                leading: const Icon(Iconsax.user),
                title: Text(name),
                subtitle: Text(email),
                trailing: IconButton(
                  icon: const Icon(Iconsax.trash),
                  onPressed: () => deleteAdminAccount(admin.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
