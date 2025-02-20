import 'package:get/get.dart';
import 'package:studiosync/core/data/repositories/widget_tree_firebase_repository.dart';
import 'package:studiosync/core/domain/repositories/i_widget_tree_repository.dart';
import 'package:studiosync/core/domain/usecases/check_role_usecase.dart';
import 'package:studiosync/core/presentation/controllers/widget_tree_controller.dart';

class WidgetTreeBinding extends Bindings {
  @override
  void dependencies() {
   
    // widget tree concrete repo
    Get.lazyPut<IWidgetTreeRepository>(() => WidgetTreeFirebaseRepository(
        firestoreService: Get.find(), iAuthRepository: Get.find()));

    // use case
    Get.put(CheckUserRoleUseCase(iWidgetTreeRepository: Get.find()));
    // controller

    Get.put(WidgetTreeController(
      checkUserRoleUseCase: Get.find(),
      getCurrentUserIdUseCase: Get.find(),
    ));
  }
}
