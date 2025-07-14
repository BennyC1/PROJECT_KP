// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/data/banner/banner_repository.dart';

void showDeleteBannerSheet(BuildContext context) async {
  final bannerList = await BannerRepository.instance.fetchBanners();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  Get.bottomSheet(
    SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Banner Aktif',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Daftar Banner
            SizedBox(
              height: 300,
              child: bannerList.isEmpty
                  ? const Center(child: Text('Tidak ada banner.'))
                  : ListView.separated(
                      itemCount: bannerList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final banner = bannerList[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              if (!isDark)
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                banner.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                              ),
                            ),
                            title: Text(
                              'Banner ${index + 1}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                              onPressed: () async {
                                final confirm = await Get.defaultDialog<bool>(
                                  title: 'Hapus Banner?',
                                  middleText: 'Yakin ingin menghapus banner ini?',
                                  confirm: ElevatedButton(
                                    onPressed: () => Get.back(result: true),
                                    child: const Text('Ya'),
                                  ),
                                  cancel: OutlinedButton(
                                    onPressed: () => Get.back(result: false),
                                    child: const Text('Tidak'),
                                  ),
                                );
                                if (confirm == true) {
                                  await BannerRepository.instance.deleteBanner(banner.id, banner.imageUrl);
                                  Get.back(); // tutup bottom sheet
                                  Get.snackbar('Berhasil', 'Banner berhasil dihapus.');
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 20),

            // Tombol Hapus Semua Banner
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete_forever),
                label: const Text('Hapus Semua Banner'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final confirm = await Get.defaultDialog<bool>(
                    title: 'Hapus Semua Banner?',
                    middleText: 'Yakin ingin menghapus semua banner?',
                    confirm: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text('Ya'),
                    ),
                    cancel: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Tidak'),
                    ),
                  );

                  if (confirm == true) {
                    await BannerRepository.instance.deleteAllBanners();
                    Get.back(); // close bottom sheet
                    Get.snackbar('Berhasil', 'Semua banner berhasil dihapus.');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
