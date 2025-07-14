import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/features/shop/controllers/reservation_controller.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';
import 'package:project_uas/features/shop/models/reservation_model.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/utils/constants/sized.dart';

class ReservationHistoryUser extends StatelessWidget {
  const ReservationHistoryUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ReservationController.instance;
    final dark = BHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: BAppBar(
        title: Text('My Reservations', style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(BSize.defaultSpace),
        child: FutureBuilder<List<ReservationModel>>(
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
              children: [
                if (pending.isNotEmpty) ...[
                  _buildSectionTitle("Reservasi Menunggu Konfirmasi", dark),
                  const SizedBox(height: 8),
                  ...pending.map((item) => _buildReservationCard(
                        item,
                        statusText: "⏳ Menunggu Konfirmasi Admin",
                        statusColor: Colors.orange,
                        showCancel: true,
                        dark: dark,
                        onCancel: () => controller.cancelUserReservation(item.id),
                      )),
                  const SizedBox(height: 24),
                ],
                if (approved.isNotEmpty) ...[
                  _buildSectionTitle("Reservasi Disetujui", dark),
                  const SizedBox(height: 8),
                  ...approved.map((item) => _buildReservationCard(
                        item,
                        statusText: "✅ Disetujui",
                        statusColor: Colors.green,
                        dark: dark,
                      )),
                  const SizedBox(height: 24),
                ],
                _buildSectionTitle("Riwayat Reservasi Dibatalkan", dark),
                const SizedBox(height: 8),
                ...cancelled.map((item) => Card(
                      elevation: 0,
                      color: dark ? Colors.red.shade900.withOpacity(0.1) : Colors.red.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.cancel, color: Colors.red),
                        title: Text("${item.capster} - ${item.packageType}"),
                        subtitle: Text(DateFormat('EEEE, dd MMM yyyy – HH:mm', 'id').format(item.datetime)),
                        trailing: Text("Rp ${item.price}"),
                      ),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool dark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: dark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildReservationCard(
    ReservationModel item, {
    required String statusText,
    required Color statusColor,
    bool showCancel = false,
    bool dark = false,
    VoidCallback? onCancel,
  }) {
    final now = DateTime.now();
    final timeLeft = item.datetime.difference(now);
    final isUpcoming = timeLeft.inSeconds > 0;

    return Card(
      color: dark ? Colors.grey.shade900 : Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${item.capster} - ${item.packageType}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(DateFormat('EEEE, dd MMM yyyy – HH:mm', 'id').format(item.datetime)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statusText,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
                ),
                Text("Rp ${item.price}", style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            if (showCancel && isUpcoming)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel, size: 18, color: Colors.red),
                  label: const Text("Batalkan", style: TextStyle(color: Colors.red)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
