import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_uas/features/shop/controllers/reservation_controller.dart';

class UploadProofModal extends StatefulWidget {
  const UploadProofModal({super.key});

  @override
  State<UploadProofModal> createState() => _UploadProofModalState();
}

class _UploadProofModalState extends State<UploadProofModal> {
  File? _imageFile;
  bool _isUploading = false;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _uploadAndSubmit() async {
    if (_imageFile == null) return;

    setState(() => _isUploading = true);

    try {
      final fileName = 'payment_proofs/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);

      // Upload with timeout
      await ref.putFile(_imageFile!).timeout(const Duration(seconds: 30));
      final url = await ref.getDownloadURL().timeout(const Duration(seconds: 15));

      debugPrint('Proof URL: $url');

      // Submit reservasi with timeout
      await ReservationController.instance.submitReservation(proofUrl: url).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Proses pengajuan terlalu lama. Silakan coba lagi.');
        },
      );

      if (mounted) Navigator.of(context).pop(true);
      Get.snackbar('Berhasil', 'Reservasi berhasil dikirim dan menunggu verifikasi.');
    } catch (e, stackTrace) {
      debugPrintStack(label: 'Upload/Submit Error', stackTrace: stackTrace);
      Get.snackbar('Error', 'Gagal mengunggah bukti: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Upload Bukti Pembayaran",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Preview gambar atau fallback
          Container(
            width: double.infinity,
            height: 220,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              color: isDark ? Colors.grey[850] : Colors.grey[100],
            ),
            child: _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined, size: 60, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("Belum ada gambar yang dipilih."),
                    ],
                  ),
          ),

          const SizedBox(height: 20),

          // Tombol pilih gambar
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.upload),
            label: const Text("Pilih Bukti Pembayaran"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 24),

          // Tombol submit
          if (_imageFile != null)
            SizedBox(
              width: double.infinity,
              child: _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _uploadAndSubmit,
                      icon: const Icon(Icons.send),
                      label: const Text("Kirim & Ajukan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}
