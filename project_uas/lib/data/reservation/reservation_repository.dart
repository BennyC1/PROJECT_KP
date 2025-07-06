import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_uas/features/shop/models/reservation_model.dart';

class ReservationRepository extends GetxController {
  static ReservationRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<ReservationModel>> fetchReservationsForCapsterOnDate(String capster, DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _db
          .collection('reservations')
          .where('capster', isEqualTo: capster)
          .where('datetime', isGreaterThanOrEqualTo: startOfDay)
          .where('datetime', isLessThan: endOfDay)
          .get();

      return querySnapshot.docs.map((doc) => ReservationModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw 'Gagal mengambil data reservasi: $e';
    }
  }

  Future<List<ReservationModel>> fetchReservationsByUserId(String userId) async {
    final snapshot = await _db
        .collection('reservations')
        .where('userId', isEqualTo: userId)
        .orderBy('datetime', descending: true)
        .get();

    return snapshot.docs.map((doc) => ReservationModel.fromJson(doc.data())).toList();
  }


  Future<void> saveReservation(ReservationModel reservation) async {
    try {
      await _db.collection('reservations').add(reservation.toJson());
    } catch (e) {
      throw 'Gagal menyimpan data reservasi: $e';
    }
  }
}
