// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:project_uas/features/shop/models/pending_reservation_model.dart';
// import 'package:project_uas/data/reservation/pending_reservation_repository.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';

// class ReservationController extends GetxController {
//   final selectedCapster = RxnString();
//   final selectedPackage = RxnString();
//   final selectedDate = Rxn<DateTime?>(null);
//   final selectedTime = RxnString();

//   int getPriceForPackage(String type) {
//     if (type == 'Dewasa') return 25000;
//     if (type == 'Anak-anak') return 20000;
//     if (type == 'Shaving') return 15000;
//     return 0;
//   }

//   Future<void> submitPendingReservation(String proofUrl) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) return;

//     final id = UniqueKey().toString();
//     final selectedDate = this.selectedDate.value;
//     final selectedTime = this.selectedTime.value;
//     if (selectedDate == null || selectedTime == null) return;

//     final datetime = DateTime.parse(
//       "${selectedDate.toIso8601String().split('T').first} $selectedTime:00",
//     );

//     print("📦 Submitting reservation with ID: $id");

//     final model = PendingReservationModel(
//       id: id,
//       userId: userId,
//       capster: selectedCapster.value!,
//       packageType: selectedPackage.value!,
//       price: getPriceForPackage(selectedPackage.value!),
//       datetime: datetime,
//       proofUrl: proofUrl,
//       createdAt: DateTime.now(),
//     );

//     await PendingReservationRepository.instance.saveReservation(model);
//     print("✅ Reservation saved!");
//   }
// }

