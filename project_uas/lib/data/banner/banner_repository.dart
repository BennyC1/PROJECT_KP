import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_uas/features/shop/models/banner_model.dart';
import 'package:project_uas/utils/exceptions/format_exceptions.dart';
import 'package:project_uas/utils/exceptions/platform_exceptions.dart';

import '../../utils/exceptions/firebase_exceptions.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  /// Variables
  final RxList<BannerModel> banners = <BannerModel>[].obs;
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

  /// Upload Banner to Firebase Storage & Firestore
  Future<void> uploadBanner({required String targetScreen}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      // ✅ Gunakan nama file tanpa spasi
      final safeFileName = image.name.replaceAll(' ', '_');
      final storageRef = FirebaseStorage.instance.ref("Banners/$safeFileName");

      // ✅ Upload image
      await storageRef.putFile(File(image.path));

      // ✅ Ambil download URL langsung dari Firebase
      final imageUrl = await storageRef.getDownloadURL();

      // ✅ Simpan data ke Firestore
      await _db.collection("Banners").add({
        "Active": true,
        "ImageUrl": imageUrl,
        "TargetScreen": targetScreen,
      });

      // ✅ Tambahkan delay agar data sinkron dulu
      await Future.delayed(const Duration(milliseconds: 500));

      // ✅ Ambil ulang semua banner ke dalam RxList
      await fetchBanners();

    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const BFormatException();
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Upload gagal: $e';
    }
  }

  // Delete all banner  
  Future<void> deleteAllBanners() async {
    try {
      final snapshot = await _db.collection('Banners').get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final imageUrl = data['ImageUrl'];

        // 1. Hapus gambar dari storage
        final ref = FirebaseStorage.instance.refFromURL(imageUrl);
        await ref.delete();

        // 2. Hapus dokumen dari Firestore
        await _db.collection("Banners").doc(doc.id).delete();
      }

      // 3. Refresh list
      await fetchBanners();

    } catch (e) {
      throw 'Gagal menghapus semua banner: $e';
    }
  }

  // delete 1 banner
  Future<void> deleteBanner(String bannerId, String imageUrl) async {
    try {
      // 1. Hapus gambar dari Firebase Storage
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();

      // 2. Hapus dokumen dari Firestore
      await _db.collection("Banners").doc(bannerId).delete();

      // 3. Refresh banners di UI
      await fetchBanners();
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } catch (e) {
      throw 'Gagal menghapus banner: $e';
    }
  }
}
  
