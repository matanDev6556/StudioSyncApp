import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';

import 'package:studiosync/shared/services/image_service.dart';

class WidgetTreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ImageService(Get.find()));
    Get.lazyPut(() => FirestoreService());
  }
}
