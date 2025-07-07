import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String id;
  final String capster;
  final String packageType;
  final int price;
  final DateTime datetime;
  final DateTime createdAt;
  final String userId;
  final String status;
  final String? proofUrl;

  ReservationModel({
    required this.id,
    required this.capster,
    required this.packageType,
    required this.price,
    required this.datetime,
    required this.createdAt,
    required this.userId,
    required this.status,
    this.proofUrl,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      capster: json['capster'] ?? '',
      packageType: json['packageType'] ?? '',
      price: json['price'] ?? 0,
      datetime: (json['datetime'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      status: json['status'] ?? 'pending',
      proofUrl: json['proofUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'capster': capster,
      'packageType': packageType,
      'price': price,
      'datetime': datetime,
      'createdAt': createdAt,
      'userId': userId,
      'status': status,
      'proofUrl': proofUrl,
    };
  }

  factory ReservationModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ReservationModel(
      id: snapshot.id,
      capster: data['capster'] ?? '',
      packageType: data['packageType'] ?? '',
      price: data['price'] ?? 0,
      datetime: (data['datetime'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      status: data['status'] ?? 'pending',
      proofUrl: data['proofUrl'],
    );
  }
}
