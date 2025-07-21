import 'package:cloud_firestore/cloud_firestore.dart';

class LayananModel {
  final String id;
  final String name;
  final String phone;
  final String imageUrl;
  final List<dynamic> packages;

  LayananModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.packages,
  });

  factory LayananModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LayananModel(
      id: doc.id,
      name: data['Name'],
      phone: data['Phone'],
      imageUrl: data['ImageUrl'],
      packages: data['Packages'] ?? [],
    );
  }
}
