import 'package:cloud_firestore/cloud_firestore.dart';

class CapsterPackageModel {
  final String id;
  final String capsterId;
  final String capsterName;
  final List<dynamic> packages;

  CapsterPackageModel({
    required this.id,
    required this.capsterId,
    required this.capsterName,
    required this.packages,
  });

  factory CapsterPackageModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CapsterPackageModel(
      id: doc.id,
      capsterId: data['capsterId'],
      capsterName: data['capsterName'],
      packages: data['packages'] ?? [],
    );
  }
}

