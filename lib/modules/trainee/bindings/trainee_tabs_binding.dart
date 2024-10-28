import 'package:get/get.dart';
import 'package:studiosync/shared/controllers/tabs_controller.dart';

class TraineeTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      GeneralTabController(
        [
          'Profile',
          'Workouts',
          'Sessions',
        ],
      ),
    );
  }
}
