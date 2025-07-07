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
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(_imageFile!);
      final url = await storageRef.getDownloadURL();

      await ReservationController.instance.submitReservation(proofUrl: url);

      if (mounted) Navigator.pop(context);
      Get.snackbar('Berhasil', 'Reservasi berhasil dikirim dan menunggu verifikasi.');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengunggah bukti: $e');
    } finally {
      setState(() => _isUploading = false);
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Upload Bukti Pembayaran",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_imageFile != null)
            Image.file(_imageFile!, width: 200)
          else
            const Text("Belum ada bukti yang dipilih."),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.upload),
            label: const Text("Pilih Bukti Pembayaran"),
          ),
          const SizedBox(height: 20),
          _isUploading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _imageFile == null ? null : _uploadAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Kirim & Ajukan"),
                ),
        ],
      ),
    );
  }
}
