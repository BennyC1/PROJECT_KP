import 'package:cloud_firestore/cloud_firestore.dart';

class PendingReservationModel {
  final String id;
  final String userId;
  final String capster;
  final String packageType;
  final int price;
  final DateTime datetime;
  final String proofUrl;
  final String status;
  final DateTime createdAt;

  PendingReservationModel({
    required this.id,
    required this.userId,
    required this.capster,
    required this.packageType,
    required this.price,
    required this.datetime,
    required this.proofUrl,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'capster': capster,
      'packageType': packageType,
      'price': price,
      'datetime': datetime,
      'proofUrl': proofUrl,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory PendingReservationModel.fromJson(Map<String, dynamic> json) {
    return PendingReservationModel(
      id: json['id'],
      userId: json['userId'],
      capster: json['capster'],
      packageType: json['packageType'],
      price: json['price'],
      datetime: (json['datetime'] as Timestamp).toDate(),
      proofUrl: json['proofUrl'],
      status: json['status'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
