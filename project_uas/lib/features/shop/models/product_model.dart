import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas/features/shop/models/brand_model.dart';

import 'product_variation_model.dart';

class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrice;
  String thumbnail;
  bool? isFeatured;
  BrandModel? brand;
  String? description;
  String? descriptiontitle;
  String? categoryId;
  List<String>? images;
  String productType;
  List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.sku,
    this.brand,
    this.date,
    this.images,
    this.salePrice = 0.0,
    this.isFeatured,
    this.categoryId,
    this.description,
    this.descriptiontitle,
    this.productVariations,
  });

  /// Create Empty func for clean code
  static ProductModel empty() => ProductModel(id: '', title: '', stock: 0, price: 0, thumbnail: '', productType: '');

  /// Json Format
  toJson () {
    return {
      'SKU': sku,
      'Title' : title,
      'Stock': stock,
      'Price' : price,
      'Images' : images ?? [],
      'Thumbnail': thumbnail,
      'SalePrice' : salePrice,
      'IsFeatured' : isFeatured,
      'CategoryId' : categoryId,
      'Brand' : brand!.toJson(),
      'Description' : description,
      'DescriptionTitle' : descriptiontitle,
      'ProductType' : productType,
      'ProductVariations': productVariations != null ? productVariations!.map((e) => e.toJson()).toList() : [],
    };
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if(document.data() == null) return ProductModel.empty();
    final data = document. data() !;
    return ProductModel(
      id: document.id,
      sku: data['SKU'],
      title: data['Title'],
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.parse((data['Price'] ?? 0.0).toString()),
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      thumbnail: data['Thumbnail' ] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      descriptiontitle: data['DescriptionTitle'] ?? '',
      productType: data['ProductType'] ?? '',
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      images: data['Images'] != null ? List<String>. from(data['Images']) : [],
      productVariations: (data['ProductVariations'] as List<dynamic>).map((e) => ProductVariationModel.fromJson(e)).toList(),
    );
  }

  // Map Json-oriented document snapshot from Firebase to Model
  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ProductModel(
      id: document.id,
      sku: data['SKU'] ?? "",
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.parse( (data['Price'] ?? 0.0).toString()),
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      brand: BrandModel.fromJson(data['Brand']),
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      productVariations:(data['ProductVariations'] as List<dynamic>).map((e) => ProductVariationModel.fromJson(e)).toList(),
    );
  }

  ProductModel copyWith({
    String? id,
    String? sku,
    String? title,
    int? stock,
    double? price,
    double? salePrice,
    String? thumbnail,
    bool? isFeatured,
    BrandModel? brand,
    String? description,
    String? descriptiontitle,
    String? categoryId,
    List<String>? images,
    String? productType,
    DateTime? date,
    List<ProductVariationModel>? productVariations,
  }) {
    return ProductModel(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      title: title ?? this.title,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      thumbnail: thumbnail ?? this.thumbnail,
      isFeatured: isFeatured ?? this.isFeatured,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      descriptiontitle: descriptiontitle ?? this.descriptiontitle,
      categoryId: categoryId ?? this.categoryId,
      images: images ?? this.images,
      productType: productType ?? this.productType,
      date: date ?? this.date,
      productVariations: productVariations ?? this.productVariations,
    );
  }
}