import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/data/reservation/reservation_repository.dart';
import 'package:project_uas/features/shop/models/reservation_model.dart';
import 'package:project_uas/utils/popups/loaders.dart';

class PackageModel {
  final String name;
  final int price;

  PackageModel({required this.name, required this.price});

  factory PackageModel.fromFirestore(Map<String, dynamic> data) {
    return PackageModel(
      name: data['Name'],
      price: data['Price'],
    );
  }
}

final FirebaseFirestore _db = FirebaseFirestore.instance;

class ReservationController extends GetxController {
  static ReservationController get instance => Get.find();

  final reservationRepository = Get.put(ReservationRepository());

  final selectedCapster = RxnString();
  final selectedPackage = RxnString();
  final selectedDate = Rxn<DateTime>();
  final selectedTime = RxnString();

  final disabledSlots = <String>[].obs;
  final timeSlots = [
    "13:00", "13:45", "14:30", "15:15",
    "16:00", "16:45", "17:30", "18:15",
    "19:00", "19:45", "20:30"
  ];

  final capsters = <String>[].obs;
  final packages = <PackageModel>[].obs;

  void resetForm() {
    selectedCapster.value = null;
    selectedPackage.value = null;
    selectedDate.value = null;
    selectedTime.value = null;
    disabledSlots.clear();
  }

  Future<void> loadCapsters() async {
    try {
      final snapshot = await _db.collection('kapster').get();
      capsters.value = snapshot.docs.map((doc) => doc['Name'] as String).toList();
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Gagal Ambil Capster', message: e.toString());
    }
  }

  Future<void> loadPackages() async {
    try {
      final snapshot = await _db.collection('Package').get();
      packages.value = snapshot.docs
          .map((doc) => PackageModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Gagal Ambil Paket', message: e.toString());
    }
  }

  Future<void> loadDisabledSlots() async {
    if (selectedCapster.value == null || selectedDate.value == null) return;

    try {
      final reservations = await reservationRepository.fetchReservationsForCapsterOnDate(
        selectedCapster.value!,
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

  int getPriceForPackage(String packageType) {
    final found = packages.firstWhereOrNull((p) => p.name == packageType);
    return found?.price ?? 0;
  }

  Future<void> submitReservation({String? proofUrl}) async {
    if (selectedCapster.value == null ||
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
      final price = getPriceForPackage(selectedPackage.value!);

      final docRef = FirebaseFirestore.instance.collection('reservations').doc(); // auto ID

      final newReservation = ReservationModel(
        docId: docRef.id, // <--- Simpan docId dari Firestore
        id: docRef.id, // bisa juga gunakan UUID/format lain kalau ingin
        capster: selectedCapster.value!,
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

  Future<List<ReservationModel>> fetchUserReservations() async {
    final userId = AuthenticationRepository.instance.authUser?.uid;

    print('Current user ID: $userId'); // ✅ Tambahkan log ini di sini

    if (userId == null || userId.isEmpty) {
      print('User ID is null or empty. Tidak bisa mengambil data.');
      return [];
    }

    return await reservationRepository.fetchReservationsByUserId(userId);
  }

  Future<List<ReservationModel>> fetchAllReservationsForAdmin() async {
  try {
    final snapshot = await _db.collection('reservations')
      .where('status', whereIn: ['pending', 'cancelled', 'approved'])
      .orderBy('datetime')
      .get();

    final data = snapshot.docs.map((doc) => ReservationModel.fromSnapshot(doc)).toList();

    print('Jumlah reservasi ditemukan: ${data.length}');
    for (var r in data) {
      print('🔥 ${r.capster} | ${r.status} | ${r.datetime}');
    }

    return data;
  } catch (e) {
    print('❌ Error fetchAllReservationsForAdmin: $e');
    rethrow;
  }
}


  Future<void> updateReservationStatus(String id, String newStatus) async {
    try {
      await _db.collection('reservations').doc(id).update({'status': newStatus});
      Get.snackbar('Berhasil', 'Status reservasi diperbarui ke $newStatus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status');
    }
  }

  Future<void> cancelUserReservation(String docId) async {
    try {
      await _db.collection('reservations').doc(docId).update({
        'status': 'cancelled',
      });
      Get.snackbar('Berhasil', 'Reservasi berhasil dibatalkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal membatalkan reservasi: $e');
    }
  }

}
