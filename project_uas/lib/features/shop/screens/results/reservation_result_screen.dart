import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas/features/shop/models/reservation_model.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:intl/intl.dart';

class ReservationsResultScreen extends StatelessWidget {
  const ReservationsResultScreen({super.key});

  Future<List<ReservationModel>> fetchApprovedReservations() async {
    final snapshot = await FirebaseFirestore.instance.collection("reservations").get();
    return snapshot.docs
        .where((doc) => doc['status'] == 'approved')
        .map((doc) => ReservationModel.fromSnapshot(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(title: const Text('Approved Reservations Report')),
      body: FutureBuilder<List<ReservationModel>>(
        future: fetchApprovedReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final reservations = snapshot.data ?? [];

          if (reservations.isEmpty) return const Center(child: Text("Tidak ada reservasi disetujui."));

          return ListView.builder(
            itemCount: reservations.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final r = reservations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text("${r.capster} - ${r.packageType}"),
                  subtitle: Text("Tanggal: ${DateFormat('dd MMM yyyy, HH:mm').format(r.datetime)}\nHarga: Rp ${r.price}\nUser: ${r.userId}"),
                  trailing: const Text("Approved", style: TextStyle(color: Colors.green)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
