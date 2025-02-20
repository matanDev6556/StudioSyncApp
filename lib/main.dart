import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/data/data_source/service_locator.dart';
import 'package:studiosync/core/presentation/bindings/global_bindings.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/router/routes.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init all servieces
  await ServiceLocator.init();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 867.4),
      child: GetMaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppStyle.deepOrange),
          useMaterial3: true,
        ),
        initialRoute: Routes.splash,
        getPages: AppRouter.routes,
        initialBinding: GlobalBindings(),
      ),
    );
  }
}
