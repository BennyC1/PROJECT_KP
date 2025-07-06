import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class BLocalStorage {
  late final GetStorage _storage;

  // Singleton instance
  static BLocalStorage? _instance;

  BLocalStorage._internal();

  factory BLocalStorage.instance() {
    _instance ??= BLocalStorage._internal();
    return _instance!;
  }

  /// Safe Instance untuk menghindari late init error
  static BLocalStorage safeInstance({bool silent = false}) {
    if (_instance == null) {
      if (!silent) {
        if (kDebugMode) {
          print('[WARNING] BLocalStorage has not been initialized. Returning dummy instance.');
        }
      }
      final fallback = BLocalStorage._internal();
      fallback._storage = GetStorage(); // default bucket (kosong)
      return fallback;
    }
    return _instance!;
  }

  static Future<void> init(String bucketName) async {
    await GetStorage.init(bucketName);
    _instance = BLocalStorage._internal();
    _instance!._storage = GetStorage(bucketName);
  }  

  // Generic method to save data
  Future<void> writeData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  // Generic method to read data
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Generic method to remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data in storage
  Future<void> clearAll() async {
    await _storage.erase();
  }
}