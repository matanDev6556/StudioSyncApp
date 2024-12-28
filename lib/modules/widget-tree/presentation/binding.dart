import 'package:get/get.dart';
import 'package:studiosync/core/presentation/bindings/global_bindings.dart';
import 'package:studiosync/modules/widget-tree/data/repositories/firebase_widget_tree_repository.dart';
import 'package:studiosync/modules/widget-tree/domain/repositories/i_widget_tree_repository.dart';
import 'package:studiosync/modules/widget-tree/domain/usecases/check_role_usecase.dart';
import 'package:studiosync/modules/widget-tree/presentation/widget_tree_controller.dart';

class WidgetTreeBinding extends Bindings {
  @override
  void dependencies() {
    GlobalBindings().dependencies();

    // widget tree dep
    Get.lazyPut<IWidgetTreeRepository>(() => WidgetTreeFirebaseRepository(
        firestoreService: Get.find(), iAuthRepository: Get.find()));

    Get.put(WidgetTreeController(
      checkUserRoleUseCase:
          Get.put(CheckUserRoleUseCase(iWidgetTreeRepository: Get.find())),
    
      getCurrentUserIdUseCase: Get.find(),
    ));
  }
}
