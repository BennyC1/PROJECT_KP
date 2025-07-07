import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/features/shop/controllers/reservation_controller.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';
import 'package:project_uas/features/shop/models/reservation_model.dart';

class ReservationHistoryScreen extends StatelessWidget {
  const ReservationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReservationController.instance;
    final dark = BHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Reservasi',
          style: TextStyle(color: dark ? Colors.white : Colors.black),
        ),
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<ReservationModel>>(
        future: controller.fetchUserReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          final pending = data.where((r) => r.status == 'pending').toList();
          final approved = data.where((r) => r.status == 'approved').toList();
          final cancelled = data.where((r) => r.status == 'cancelled').toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (pending.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reservasi Menunggu Konfirmasi",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...pending.map((item) {
                      final now = DateTime.now();
                      final timeLeft = item.datetime.difference(now);
                      final isUpcoming = timeLeft.inSeconds > 0;

                      return Card(
                        color: Colors.orange.shade50,
                        child: ListTile(
                          title: Text("${item.capster} - ${item.packageType}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('EEEE, dd MMM yyyy – HH:mm', 'id').format(item.datetime)),
                              const SizedBox(height: 4),
                              const Text("⏳ Menunggu Konfirmasi Admin", style: TextStyle(color: Colors.orange)),
                              if (isUpcoming)
                                TextButton(
                                  onPressed: () => controller.cancelUserReservation(item.id),
                                  child: const Text("Batalkan"),
                                ),
                            ],
                          ),
                          trailing: Text("Rp ${item.price}"),
                        ),
                      );
                    }).toList(),
                    const Divider(height: 32),
                  ],
                ),

              if (approved.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reservasi Disetujui",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...approved.map((item) {
                      final now = DateTime.now();
                      final timeLeft = item.datetime.difference(now);
                      final isUpcoming = timeLeft.inSeconds > 0;

                      return Card(
                        color: Colors.green.withOpacity(0.1),
                        child: ListTile(
                          title: Text("${item.capster} - ${item.packageType}"),
                          subtitle: Text(isUpcoming
                              ? "✅ Disetujui • Tersisa ${timeLeft.inHours} jam ${timeLeft.inMinutes % 60} menit"
                              : "✅ Disetujui • Sudah Lewat"),
                          trailing: Text("Rp ${item.price}"),
                        ),
                      );
                    }).toList(),
                    const Divider(height: 32),
                  ],
                ),

              const Text(
                "Riwayat Reservasi Dibatalkan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...cancelled.map((item) => ListTile(
                    leading: const Icon(Icons.cancel, color: Colors.red),
                    title: Text("${item.capster} - ${item.packageType}"),
                    subtitle: Text(DateFormat('EEEE, dd MMM yyyy – HH:mm', 'id').format(item.datetime)),
                    trailing: Text("Rp ${item.price}"),
                  )),
            ],
          );
        },
      ),
    );
  }
}
