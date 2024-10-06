import 'package:get/get.dart';

import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class TraineeController extends GetxController {
  TraineeController();

  Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);
}
