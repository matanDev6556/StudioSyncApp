import 'package:get/get.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/core/presentation/bindings/widget_tree_binding.dart';
import 'package:studiosync/modules/lessons/presentation/bindings/lessons_bindings.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/auth/presentation/bindings/login_bindng.dart';
import 'package:studiosync/modules/workouts/presentation/bindings/workouts_bindings.dart';

// this bindings aplly by widget tree bindings
class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    // comoon bidnings

    LoginBinding().dependencies();
    LessonsBindings().dependencies();
    WorkoutsBindings().dependencies();
    WidgetTreeBinding().dependencies();

    // common usecases
    Get.put(PickImageUseCase(iStorageService: Get.find()));
    Get.put(LogoutUseCase(iAuthRepository: Get.find()));
  }
}
