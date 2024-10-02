import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/core/services/firebase/storage_services.dart';

class ServiceLocator {
  static Future<void> init() async {
    try {
      Get.put(AuthService());
      Get.put(FirestoreService());
      Get.put(StorageServices());
      debugPrint('Services initialized successfully');
    } catch (e) {
      debugPrint('Error initializing services: $e');
    }
  }
}
