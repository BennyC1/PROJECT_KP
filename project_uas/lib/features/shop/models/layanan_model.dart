import 'package:cloud_firestore/cloud_firestore.dart';

class CapsterModel {
  final String id;
  final String name;
  final String phone;
  final String imageUrl;
  final List<dynamic> packages;

  CapsterModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.packages,
  });

  factory CapsterModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CapsterModel(
      id: doc.id,
      name: data['Name'],
      phone: data['Phone'],
      imageUrl: data['ImageUrl'],
      packages: data['Packages'] ?? [],
    );
  }
}
