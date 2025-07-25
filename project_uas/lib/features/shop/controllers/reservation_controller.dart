import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/data/reservation/reservation_repository.dart';
import 'package:project_uas/features/shop/models/capsterpackage_model.dart';
import 'package:project_uas/features/shop/models/reservation_model.dart';
import 'package:project_uas/utils/popups/loaders.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

class ReservationController extends GetxController {
  static ReservationController get instance => Get.find();

  final reservationRepository = Get.put(ReservationRepository());

  final capsterList = <CapsterPackageModel>[].obs;
  final selectedCapsterLayanan = Rxn<CapsterPackageModel>();
  final selectedCapsterImageUrl = RxnString();
  final selectedCapsterPhone = RxnString();
  final selectedPackage = RxnString();
  final selectedDate = Rxn<DateTime>();
  final selectedTime = RxnString();

  final disabledSlots = <String>[].obs;
  final timeSlots = [
    "13:00", "13:45", "14:30", "15:15",
    "16:00", "16:45", "17:30", "18:15",
    "19:00", "19:45", "20:30"
  ];

  /// Reset form
  void resetForm() {
    selectedCapsterLayanan.value = null;
    selectedPackage.value = null;
    selectedDate.value = null;
    selectedTime.value = null;
    selectedCapsterImageUrl.value = null;
    selectedCapsterPhone.value = null;
    disabledSlots.clear();
  }

  /// Ambil detail capster (image & phone) berdasarkan capsterId
  Future<void> loadCapsterDetail(String capsterId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('Capster').doc(capsterId).get();
      final data = doc.data();

      selectedCapsterImageUrl.value = data?['ImageUrl'];
      selectedCapsterPhone.value = data?['Phone'];
    } catch (e) {
      selectedCapsterImageUrl.value = null;
      selectedCapsterPhone.value = null;
      print("Gagal ambil detail capster: $e");
    }
  }

  /// Ambil layanan (capster + package dari CapsterPackage)
  Future<void> loadLayanan() async {
    final snapshot = await FirebaseFirestore.instance.collection('CapsterPackage').get();
    final data = snapshot.docs.map((doc) => CapsterPackageModel.fromSnapshot(doc)).toList();
    capsterList.assignAll(data);
  }

  /// Cek waktu yang sudah direservasi
  Future<void> loadDisabledSlots() async {
    if (selectedCapsterLayanan.value == null || selectedDate.value == null) return;

    try {
      final reservations = await reservationRepository.fetchReservationsForCapsterOnDate(
        selectedCapsterLayanan.value!.capsterName,
        selectedDate.value!,
      );

      final reservedTimes = reservations.map((res) {
        return DateFormat('HH:mm').format(res.datetime);
      }).toList();

      disabledSlots.assignAll(reservedTimes);
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Gagal', message: e.toString());
    }
  }

  /// Simpan reservasi
  Future<void> submitReservation({String? proofUrl}) async {
    if (selectedCapsterLayanan.value == null ||
        selectedPackage.value == null ||
        selectedDate.value == null ||
        selectedTime.value == null) {
      BLoaders.warningSnackBar(title: 'Oops', message: 'Lengkapi semua data terlebih dahulu.');
      return;
    }

    try {
      final date = selectedDate.value!;
      final timeParts = selectedTime.value!.split(':');
      final datetime = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      final userId = AuthenticationRepository.instance.authUser!.uid;
      final selectedCapster = selectedCapsterLayanan.value!;
      final price = selectedCapster.packages
          .firstWhere((pkg) => pkg['name'] == selectedPackage.value)['price'];

      final docRef = FirebaseFirestore.instance.collection('reservations').doc();

      final newReservation = ReservationModel(
        docId: docRef.id,
        id: docRef.id,
        capster: selectedCapster.capsterName,
        packageType: selectedPackage.value!,
        price: price,
        datetime: datetime,
        createdAt: DateTime.now(),
        userId: userId,
        status: 'pending',
        proofUrl: proofUrl,
      );

      await docRef.set(newReservation.toJson());

      BLoaders.successSnackBar(title: 'Sukses', message: 'Reservasi berhasil disimpan.');
      resetForm();
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Ambil reservasi user
  Future<List<ReservationModel>> fetchUserReservations() async {
    final userId = AuthenticationRepository.instance.authUser?.uid;
    if (userId == null || userId.isEmpty) return [];
    return await reservationRepository.fetchReservationsByUserId(userId);
  }

  /// Ambil semua reservasi untuk admin
  Stream<List<ReservationModel>> fetchAllReservationsForAdminStream() {
    try {
      return _db
          .collection('reservations')
          .where('status', whereIn: ['pending', 'cancelled', 'approved'])
          .orderBy('datetime')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) => ReservationModel.fromSnapshot(doc)).toList();
          });
    } catch (e) {
      print('❌ Error fetchAllReservationsForAdminStream: $e');
      rethrow;
    }
  }

  /// Update status reservasi (admin)
  Future<void> updateReservationStatus(String id, String newStatus) async {
    try {
      await _db.collection('reservations').doc(id).update({'status': newStatus});
      Get.snackbar('Berhasil', 'Status reservasi diperbarui ke $newStatus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status');
    }
  }

  /// Cancel reservasi oleh user
  Future<void> cancelUserReservation(String docId) async {
    try {
      await _db.collection('reservations').doc(docId).update({'status': 'cancelled'});
      Get.snackbar('Berhasil', 'Reservasi berhasil dibatalkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal membatalkan reservasi: $e');
    }
  }
}
