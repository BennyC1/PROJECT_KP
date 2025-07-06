import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/features/shop/models/reservation_model.dart';
import 'package:project_uas/data/reservation/reservation_repository.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas/data/reservation/pending_reservation_repository.dart';
import 'package:project_uas/features/shop/models/pending_reservation_model.dart';

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

  final packageOptions = ['Dewasa', 'Anak-anak', 'Shaving'];

  /// 🔁 Reset semua nilai saat buka halaman
  void resetForm() {
    selectedCapster.value = null;
    selectedPackage.value = null;
    selectedDate.value = null;
    selectedTime.value = null;
    disabledSlots.clear();
  }

  /// ✅ Kunci waktu yang sudah dipesan
  Future<void> loadDisabledSlots() async {
    if (selectedCapster.value == null || selectedDate.value == null) return;

    try {
      final reservations = await reservationRepository.fetchReservationsForCapsterOnDate(
        selectedCapster.value!,
        selectedDate.value!,
      );

      final reservedTimes = reservations.map((res) {
        return DateFormat('HH:mm').format(res.datetime); // Format konsisten
      }).toList();

      disabledSlots.assignAll(reservedTimes);
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Gagal', message: e.toString());
    }
  }

  /// ✅ Ambil harga berdasarkan paket
  int getPriceForPackage(String packageType) {
    switch (packageType) {
      case 'Dewasa':
        return 25000;
      case 'Anak-anak':
        return 20000;
      case 'Shaving':
        return 15000;
      default:
        return 0;
    }
  }

  /// ✅ Simpan reservasi ke Firestore
  Future<void> submitReservation() async {
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

      final newReservation = ReservationModel(
        id: UniqueKey().toString(),
        capster: selectedCapster.value!,
        packageType: selectedPackage.value!,
        price: price,
        datetime: datetime,
        createdAt: DateTime.now(),
        userId: userId,
      );

      await reservationRepository.saveReservation(newReservation);

      BLoaders.successSnackBar(title: 'Sukses', message: 'Reservasi berhasil disimpan.');

      resetForm();
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<List<ReservationModel>> fetchUserReservations() async {
    final userId = AuthenticationRepository.instance.authUser!.uid;
    return await reservationRepository.fetchReservationsByUserId(userId);
  }

  Future<List<PendingReservationModel>> fetchPendingReservations() async {
    final userId = AuthenticationRepository.instance.authUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('pending_reservations')
        .where('userId', isEqualTo: userId)
        .orderBy('datetime')
        .get();

    return snapshot.docs
        .map((doc) => PendingReservationModel.fromJson(doc.data()))
        .toList();
  }



  Future<void> submitPendingReservation(String proofUrl) async {
  print('🔥 Memulai submitPendingReservation');
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    BLoaders.errorSnackBar(title: 'Gagal', message: 'User tidak ditemukan.');
    return;
  }

  final capster = selectedCapster.value;
  final package = selectedPackage.value;
  final date = selectedDate.value;
  final time = selectedTime.value;

  if (capster == null || package == null || date == null || time == null) {
    BLoaders.warningSnackBar(title: 'Oops', message: 'Lengkapi semua data reservasi terlebih dahulu.');
    return;
  }

  final timeParts = time.split(':');
  final datetime = DateTime(date.year, date.month, date.day, int.parse(timeParts[0]), int.parse(timeParts[1]));

  final pendingModel = PendingReservationModel(
    id: UniqueKey().toString(),
    userId: userId,
    capster: capster,
    packageType: package,
    price: getPriceForPackage(package),
    datetime: datetime,
    proofUrl: proofUrl,
    createdAt: DateTime.now(),
  );

  await PendingReservationRepository.instance.saveReservation(pendingModel);

  BLoaders.successSnackBar(title: 'Berhasil', message: 'Reservasi menunggu verifikasi admin.');

  resetForm(); // bersihkan form setelah submit
}
}
