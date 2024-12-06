import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/core/services/firebase/storage_services.dart';
import 'package:studiosync/core/services/iauth_service.dart';
import 'package:studiosync/shared/services/image_service.dart';

class ServiceLocator {
  static Future<void> init() async {
    try {
      Get.put<IAuthService>(FirebaseAuthService());
      Get.put(FirestoreService());
      Get.put(StorageServices());
      Get.put(ImageService(Get.find()));

      debugPrint('Services initialized successfully');
    } catch (e) {
      debugPrint('Error initializing services: $e');
    }
  }
}
