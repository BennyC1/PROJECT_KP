import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/features/shop/controllers/product/order_controller.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class PaymentProofScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentProofScreen({super.key, required this.totalAmount});

  @override
  State<PaymentProofScreen> createState() => _PaymentProofScreenState();
}

class _PaymentProofScreenState extends State<PaymentProofScreen> {
  File? _proofImage;
  final picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (pickedFile != null) {
      setState(() {
        _proofImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitPaymentProof() async {
    final userId = AuthenticationRepository.instance.authUser?.uid;

    if (userId == null || userId.isEmpty) {
      BLoaders.errorSnackBar(title: 'Error', message: 'User tidak ditemukan.');
      return;
    }

    setState(() => _isLoading = true);

    final url = await uploadPaymentProof(_proofImage!, userId);
    if (url != null) {
      Get.back(); // kembali ke halaman sebelumnya
      Get.snackbar('Sukses', 'Bukti pembayaran berhasil diunggah.');
      Get.find<OrderController>().processOrder(widget.totalAmount, paymentProofUrl: url);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bukti Pembayaran"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Scan QRIS dan unggah bukti pembayaran Anda untuk melanjutkan.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            /// QR Code Preview + Zoom
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: InteractiveViewer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset('assets/payment/barcode1.jpg', fit: BoxFit.contain),
                      ),
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/payment/barcode1.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// Upload Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload),
                label: const Text("Pilih Bukti Pembayaran"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.blueAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Bukti Preview
            if (_proofImage != null)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _proofImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const Spacer(),

            /// Tombol Konfirmasi hanya muncul jika bukti sudah diunggah
            if (_proofImage != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: const Text(
                    "Konfirmasi & Proses Pesanan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  onPressed: _isLoading ? null : _submitPaymentProof,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<String?> uploadPaymentProof(File file, String userId) async {
  try {
    final ref = FirebaseStorage.instance
        .ref()
        .child('payment_proofs')
        .child('$userId-${DateTime.now().millisecondsSinceEpoch}.jpg');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  } catch (e) {
    BLoaders.errorSnackBar(title: 'Upload Error', message: e.toString());
    return null;
  }
}
