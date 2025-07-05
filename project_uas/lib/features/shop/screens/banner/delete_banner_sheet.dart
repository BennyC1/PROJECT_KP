import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/data/banner/banner_repository.dart';

void showDeleteBannerSheet(BuildContext context) async {
  final bannerList = await BannerRepository.instance.fetchBanners(); // Ambil data langsung

  Get.bottomSheet(
    SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Banner Aktif',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// Banner ListView
            SizedBox(
              height: 300,
              child: bannerList.isEmpty
                  ? const Center(child: Text('Tidak ada banner.'))
                  : ListView.separated(
                      itemCount: bannerList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final banner = bannerList[index];
                        return Row(
                          children: [
                            /// Gambar Banner
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                banner.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),

                            /// Tombol Delete
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
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
                            )
                          ],
                        );
                      },
                    ),
            ),

            const SizedBox(height: 20),

            /// Tombol Hapus Semua Banner
            ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever),
              label: const Text('Hapus Semua Banner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            )
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
