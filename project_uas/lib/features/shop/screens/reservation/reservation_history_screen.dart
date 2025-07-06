import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/features/shop/controllers/reservation_controller.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';
import 'package:project_uas/features/shop/models/pending_reservation_model.dart';
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
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          controller.fetchUserReservations(),
          controller.fetchPendingReservations(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final confirmed = List<ReservationModel>.from(snapshot.data?[0] ?? []);
          final pending = List<PendingReservationModel>.from(snapshot.data?[1] ?? []);

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
                      final isApproved = item.status == 'approved';
                      final now = DateTime.now();
                      final timeLeft = item.datetime.difference(now);
                      final isUpcoming = timeLeft.inSeconds > 0;

                      return Card(
                        color: isApproved
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.shade900,
                        child: ListTile(
                          title: Text("${item.capster} - ${item.packageType}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('EEEE, dd MMM yyyy – HH:mm', 'id').format(item.datetime)),
                              const SizedBox(height: 4),
                              if (isApproved && isUpcoming)
                                Text(
                                  "✅ Disetujui • Tersisa ${timeLeft.inHours} jam ${timeLeft.inMinutes % 60} menit",
                                  style: const TextStyle(color: Colors.green),
                                )
                              else if (isApproved && !isUpcoming)
                                const Text("✅ Disetujui • Sudah Lewat", style: TextStyle(color: Colors.grey))
                              else
                                const Text("⏳ Menunggu Konfirmasi Admin", style: TextStyle(color: Colors.orange)),
                            ],
                          ),
                          trailing: Text("Rp ${item.price}"),
                        ),
                      );
                    }).toList(),
                    const Divider(height: 32),
                  ],
                ),

              const Text(
                "Riwayat Reservasi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...confirmed.map((item) => ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
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
