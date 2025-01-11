import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/data/data_source/firebase/firestore_service.dart';
import 'package:studiosync/core/data/data_source/firebase/auth_service.dart';
import 'package:studiosync/core/data/data_source/firebase/storage_services.dart';
import 'package:studiosync/core/domain/repositories/i_storage_service.dart';
import 'package:studiosync/modules/auth/data/repositories/firebase_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/core/domain/repositories/i_local_storage_repository.dart';
import 'package:studiosync/core/data/repositories/shared_refrences_repository.dart';

class ServiceLocator {
  static Future<void> init() async {
    try {
      Get.put(FirebaseAuthService());
      Get.put(FirestoreService());
      Get.put<IAuthRepository>(
          FirebaseAuthRepository(firebaseAuthService: Get.find()));
      Get.put<FirebaseAuthRepository>(
          FirebaseAuthRepository(firebaseAuthService: Get.find())); // Add this
      Get.put<IStorageService>(StorageServices());
      Get.put<ILocalStorageRepository>(SharedPreferencesRepository());
     

      debugPrint('Services initialized successfully');
    } catch (e) {
      debugPrint('Error initializing services: $e');
    }
  }
}
