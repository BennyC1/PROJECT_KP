import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_uas/features/shop/models/banner_model.dart';
import 'package:project_uas/utils/exceptions/format_exceptions.dart';
import 'package:project_uas/utils/exceptions/platform_exceptions.dart';

import '../../utils/exceptions/firebase_exceptions.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  /// Get all order related to current User
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final result = await _db.collection('Banners').where('Active', isEqualTo: true).get();
      return result.docs.map((documentSnapshot) => BannerModel.fromSnapshot(documentSnapshot)).toList();
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BFormatException ();
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
    throw 'Something went wrong while fetching Banners. ';
    }
  }

  /// Upload Banners to the Cloud Firebase
}
  
