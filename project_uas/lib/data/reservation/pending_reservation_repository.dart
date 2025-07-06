import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_uas/features/shop/models/pending_reservation_model.dart';

class PendingReservationRepository extends GetxController {
  static PendingReservationRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> saveReservation(PendingReservationModel data) async {
    try {
      print('🚀 Menyimpan reservasi pending dengan ID: ${data.id}');
      await _db
          .collection('pending_reservations')
          .doc(data.id)
          .set(data.toJson());
      print('✅ Reservasi pending berhasil disimpan ke Firestore.');
    } catch (e) {
      print('❌ Gagal menyimpan reservasi: $e');
      rethrow; // lempar lagi agar bisa ditangani di controller
    }
  }
}
