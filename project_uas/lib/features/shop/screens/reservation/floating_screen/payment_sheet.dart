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
      child: Wrap(
        children: [
          Center(
            child: Container(
              height: 5,
              width: 40,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const Center(
            child: Text(
              "Pilih Metode Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text("Bayar dengan QRIS"),
            onTap: () {
              Navigator.pop(context); // Tutup sheet pertama

              // Tampilkan modal QRIS
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const QrisImageModal(),
              );
            },
          ),

          const SizedBox(height: 10),

          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batalkan", style: TextStyle(color: Colors.redAccent)),
            ),
          ),
        ],
      ),
    );
  }
}
