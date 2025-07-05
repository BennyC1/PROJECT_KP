import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/exceptions/firebase_exceptions.dart';
import 'package:project_uas/utils/exceptions/platform_exceptions.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  /// Firestore instance for database interactions.
  final _db = FirebaseFirestore.instance;

  // Get Limited featured products
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
        final snapshot = await _db.collection('Products').where('IsFeatured', isEqualTo: true).limit(30).get();
        return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
      } on FirebaseException catch (e) {
        throw BFirebaseException(e.code).message;
      } on PlatformException catch (e) {
        throw BPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again' ;
    }
  }

  // Get All Featured Products
  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
        final snapshot = await _db.collection('Products').where('IsFeatured', isEqualTo: true).get();
        return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
      } on FirebaseException catch (e) {
        throw BFirebaseException(e.code).message;
      } on PlatformException catch (e) {
        throw BPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again' ;
    }
  }

  // Get Products based on brand
  Future<List<ProductModel>> fetchProductsByQuery(Query query) async {
    try {
        final querySnapshot = await query.get();
        final List<ProductModel> productList = querySnapshot.docs.map((doc) => ProductModel.fromQuerySnapshot(doc)).toList();
        return productList;
      } on FirebaseException catch (e) {
        throw BFirebaseException(e.code).message;
      } on PlatformException catch (e) {
        throw BPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again' ;
    }
  }

  // GetFavorite Product
  Future<List<ProductModel>> getFavouriteProducts(List<String> productIds) async {
    try {
      if (productIds.isEmpty) return [];
      final snapshot = await _db.collection('Products').where(FieldPath.documentId, whereIn: productIds).get();
      return snapshot.docs.map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot)).toList();
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get product for brand
  Future<List<ProductModel>> getProductsForBrand({required String brandId, int limit = -1}) async {
    try {
      final querySnapshot = limit == -1
        ? await _db.collection('Products').where('Brand.Id', isEqualTo: brandId).get()
        : await _db.collection('Products').where('Brand.Id', isEqualTo: brandId).limit(limit).get();
      
      final products = querySnapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();

      return products;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again' ;
    }
  }

  // Get product for category
  Future<List<ProductModel>> getProductsForCategory({required String categoryId, int limit = 4}) async {
    try {
      QuerySnapshot productCategoryQuery = limit == -1
        ? await _db.collection('ProductCategory').where('categoryId', isEqualTo: categoryId).get()
        : await _db.collection('ProductCategory').where('categoryId', isEqualTo: categoryId).limit(limit).get();
      
      // Extract productIds from the documents
      List<String> productIds = productCategoryQuery.docs.map((doc) => doc['productId' ] as String) . toList();

      // Query to get all documents where the brandId is in the list of brandIds, FieldPath.documentId to query documents in Collection
      final productsQuery = await _db.collection('Products' ).where(FieldPath.documentId, whereIn: productIds).get();

      // Extract brand names or other relevant data from the documents
      List<ProductModel> products = productsQuery.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();

      return products;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again' ;
    }
  }

   Future<String> generateNextProductId() async {
    final snapshot = await _db.collection('Products').orderBy(FieldPath.documentId, descending: true).limit(1).get();
    if (snapshot.docs.isEmpty) return '001';
    final lastId = snapshot.docs.first.id;
    final nextId = int.parse(lastId) + 1;
    return nextId.toString().padLeft(3, '0');
  }

  Future<String> uploadImage(File imageFile, String imageName) async {
    final ref = FirebaseStorage.instance.ref('Products/Images/$imageName');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> uploadProduct(ProductModel product) async {
    final productId = await generateNextProductId();
    product.id = productId;

    final thumbnailFile = File(product.thumbnail);
    final thumbnailUrl = await uploadImage(thumbnailFile, 'thumb_$productId.jpg');
    product.thumbnail = thumbnailUrl;

    List<String> uploadedImages = [];
    for (var i = 0; i < product.images!.length; i++) {
      final imageUrl = await uploadImage(File(product.images![i]), 'product_${productId}_$i.jpg');
      uploadedImages.add(imageUrl);
    }
    product.images = uploadedImages;

    for (var variation in product.productVariations ?? []) {
      final varImage = await uploadImage(File(variation.image), 'variation_${productId}_${variation.id}.jpg');
      variation.image = varImage;
    }

    await _db.collection('Products').doc(productId).set(product.toJson());
  }

}