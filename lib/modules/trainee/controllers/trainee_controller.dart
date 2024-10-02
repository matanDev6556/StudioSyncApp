import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:studiosync/core/shared/controllers/user_controller.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class TraineeController extends UserController {
  TraineeController(super.authService, super.firestoreService);

  Rx<TraineeModel?> trainer = Rx<TraineeModel?>(null);
}
