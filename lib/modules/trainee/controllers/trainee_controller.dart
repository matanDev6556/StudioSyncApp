import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class TraineeController extends GetxController {
  final AuthService authService;
  TraineeController({required this.authService});

  Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);

  void logout() async {
    await authService.signOut();
    Get.offAllNamed(Routes.login);
  }
}
