import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/data/authentication/repositories_authentication.dart';
import 'package:project_uas/data/reservation/pending_reservation_repository.dart';
import 'package:project_uas/data/reservation/reservation_repository.dart';
import 'package:project_uas/features/shop/models/pending_reservation_model.dart';
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
      final snapshot = await FirebaseFirestore.instance.collection('kapster').get();
      capsters.value = snapshot.docs.map((doc) => doc['Name'] as String).toList();
    } catch (e) {
      BLoaders.errorSnackBar(title: 'Gagal Ambil Capster', message: e.toString());
    }
  }

  Future<void> loadPackages() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Package').get();
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
    resetForm();
  }
}
