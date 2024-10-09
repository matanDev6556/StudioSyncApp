import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/core/services/firebase/storage_services.dart';
import 'package:studiosync/shared/services/image_service.dart';
import 'package:studiosync/shared/services/user_firestore_service.dart';

class ServiceLocator {
  static Future<void> init() async {
    try {
      Get.put(AuthService());
      Get.put(FirestoreService());
      Get.put(StorageServices());
      Get.put(ImageService(Get.find()));
      Get.put(UserFirestoreService(Get.find()));
      debugPrint('Services initialized successfully');
    } catch (e) {
      debugPrint('Error initializing services: $e');
    }
  }
}
