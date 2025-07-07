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

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _proofImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Bukti Pembayaran"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Silakan scan QRIS berikut dan upload bukti pembayaran Anda.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            /// QRIS Gambar
            Image.asset('assets/payment/barcode1.jpg', height: 200),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload),
              label: const Text("Upload Bukti Pembayaran"),
            ),

            const SizedBox(height: 20),
            if (_proofImage != null)
              Image.file(_proofImage!, height: 200, fit: BoxFit.cover),

            const Spacer(),

            ElevatedButton(
              onPressed: _proofImage == null
                  ? null
                  : () async {
                      final userId = AuthenticationRepository.instance.authUser?.uid;

                      if (userId == null || userId.isEmpty) {
                        BLoaders.errorSnackBar(title: 'Error', message: 'User tidak ditemukan.');
                        return;
                      }

                      final url = await uploadPaymentProof(_proofImage!, userId);

                      if (url != null) {
                        orderController.processOrder(widget.totalAmount, paymentProofUrl: url);
                      }
                    },
              child: const Text("Konfirmasi & Proses Pesanan"),
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
