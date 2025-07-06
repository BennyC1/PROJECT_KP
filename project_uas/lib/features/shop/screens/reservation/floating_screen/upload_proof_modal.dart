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
      final id = UniqueKey().toString();
      final storageRef = FirebaseStorage.instance.ref().child('payment_proofs/$id.jpg');
      await storageRef.putFile(_imageFile!);
      final url = await storageRef.getDownloadURL();

      await ReservationController.instance.submitPendingReservation(url);

      if (context.mounted) {
        Navigator.pop(context); // tutup modal
        Get.snackbar('Berhasil', 'Reservasi menunggu verifikasi admin');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengunggah bukti: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Wrap(
        children: [
          const Center(
            child: Text(
              "Upload Bukti Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: _imageFile != null
                ? Image.file(_imageFile!, width: 200)
                : const Text("Belum ada bukti yang dipilih."),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload),
              label: const Text("Pilih Bukti Pembayaran"),
            ),
          ),
          const SizedBox(height: 20),
          if (_isUploading)
            const Center(child: CircularProgressIndicator())
          else
            Center(
              child: ElevatedButton(
                onPressed: _imageFile == null ? null : _uploadAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Kirim & Ajukan"),
              ),
            ),
        ],
      ),
    );
  }
}
