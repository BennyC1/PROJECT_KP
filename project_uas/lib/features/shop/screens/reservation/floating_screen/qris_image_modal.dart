import 'package:flutter/material.dart';
import 'package:project_uas/features/shop/screens/reservation/floating_screen/upload_proof_modal.dart';

class QrisImageModal extends StatelessWidget {
  const QrisImageModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Wrap(
        children: [
          const Center(
            child: Text(
              "Scan QRIS untuk Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Image.asset(
              'assets/payment/barcode1.jpg', 
              width: 200,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); 

                // Lanjut ke modal upload bukti
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const UploadProofModal(),
                );
              },
              icon: const Icon(Icons.check_circle),
              label: const Text("Saya Sudah Bayar"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Kembali", style: TextStyle(color: Colors.redAccent)),
            ),
          ),
        ],
      ),
    );
  }
}
