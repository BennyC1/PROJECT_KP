import 'package:flutter/material.dart';
import 'package:project_uas/features/shop/screens/reservation/floating_screen/qris_image_modal.dart';

class PaymentSheet extends StatelessWidget {
  const PaymentSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Garis atas kecil
          Container(
            height: 5,
            width: 40,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[500],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const Text(
            "Pilih Metode Pembayaran",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          // Tombol QRIS
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context); // Tutup sheet pertama

              // Tampilkan modal QRIS
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const QrisImageModal(),
              );
            },
            icon: const Icon(Icons.qr_code_2_rounded, size: 24),
            label: const Text(
              "Bayar dengan QRIS",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
          ),

          const SizedBox(height: 16),

          // Tombol Batalkan
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Batalkan",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
