import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/features/shop/controllers/reservation_controller.dart';
import 'package:project_uas/features/shop/models/reservation_model.dart';

class AdminConfirmReservationScreen extends StatelessWidget {
  const AdminConfirmReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReservationController.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Reservasi')),
      body: FutureBuilder<List<ReservationModel>>(
        future: controller.fetchAllReservationsForAdmin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('Tidak ada reservasi yang perlu dikonfirmasi.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Judul Reservasi
                      Text(
                        '${item.capster} - ${item.packageType}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),

                      /// Waktu dan Status
                      Text(DateFormat('EEEE, dd MMM yyyy – HH:mm', 'id').format(item.datetime)),
                      Text('Status: ${item.status}'),

                      /// Bukti Pembayaran (jika ada)
                      if (item.proofUrl != null && item.proofUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                child: InteractiveViewer(
                                  child: Image.network(item.proofUrl!),
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(item.proofUrl!, height: 80),
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      /// Tombol Konfirmasi & Batalkan
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: item.status == 'pending'
                                  ? () => controller.updateReservationStatus(item.docId, 'approved')
                                  : null,
                              child: const Text('Konfirmasi'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: item.status == 'pending'
                                  ? () => controller.updateReservationStatus(item.docId, 'cancelled')
                                  : null,
                              child: const Text('Batalkan'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
 