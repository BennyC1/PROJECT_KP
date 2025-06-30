class ProductVariationModel {
  final String id;
  String image;

  ProductVariationModel({
    required this.id,
    this.image = '',
  });

  /// Create Empty func for clean code
  static ProductVariationModel empty() => ProductVariationModel(id: '');

  /// Json Format
  toJson () {
    return {
      'Id': id,
      'image' : image,
    };
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory ProductVariationModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if(data.isEmpty) return ProductVariationModel.empty();
    return ProductVariationModel(
      id: data['Id'] ?? '',
      image: data['image'] ?? '',
    ); 
  }
}