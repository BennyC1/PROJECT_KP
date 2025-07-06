import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas/utils/constants/colors.dart';

void showDeleteBrandSheet(BuildContext context) {
  final isDark = Get.isDarkMode;
  final theme = Theme.of(context);
  final CollectionReference brandsRef = FirebaseFirestore.instance.collection('Brands');

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Delete Brands', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          StreamBuilder<QuerySnapshot>(
            stream: brandsRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No brands found.', style: theme.textTheme.bodyMedium);
              }

              final brands = snapshot.data!.docs;

              return SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(brand['Image']),
                      ),
                      title: Text(brand['Name'], style: theme.textTheme.bodyLarge),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await brandsRef.doc(brand.id).delete();
                          Get.snackbar('Success', 'Brand ${brand['Name']} deleted');
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () async {
              final snapshot = await brandsRef.get();
              for (var doc in snapshot.docs) {
                await brandsRef.doc(doc.id).delete();
              }
              Get.back();
              Get.snackbar('Success', 'All brands deleted');
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text('Delete All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: BColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
