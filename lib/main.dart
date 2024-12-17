import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/config/firebase_options.dart';
import 'package:studiosync/core/domain/repositories/i_storage_service.dart';
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/core/services/service_locator.dart';
import 'package:studiosync/core/router/app_touter.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/modules/auth/data/repositories/firebase_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/auth/domain/usecases/login_usecase.dart';
import 'package:studiosync/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:studiosync/modules/auth/presentation/controllers/login_controller.dart';
import 'package:studiosync/shared/controllers/widget_tree_controller.dart';
import 'package:studiosync/core/theme/app_style.dart';

Future<void> main() async {
  // init firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // init all servieces
  await ServiceLocator.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 900),
      child: GetMaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppStyle.deepOrange),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splash,
        getPages: AppRouter.routes,
        initialBinding: BindingsBuilder(
          () {
            Get.put(
              WidgetTreeController(
                  Get.find<IAuthRepository>(), Get.find(), Get.find()),
            );

            Get.put(PickImageUseCase(Get.find<IStorageService>()));

            Get.lazyPut(() => LoginUseCase(Get.find<IAuthRepository>()));
            Get.lazyPut(
                () => LogoutUseCase(Get.find<FirebaseAuthRepository>()));
            Get.put(LoginController(Get.find(), Get.find()));
          },
        ),
      ),
    );
  }
}
