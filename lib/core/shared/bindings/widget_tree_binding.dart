import 'package:get/get.dart';
import 'package:studiosync/core/shared/services/image_service.dart';
import 'package:studiosync/core/shared/services/user_firestore_service.dart';

class WidgetTreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ImageService(Get.find()));
    Get.lazyPut(() => UserFirestoreService(Get.find()));
  }
}
