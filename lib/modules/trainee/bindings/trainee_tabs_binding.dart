import 'package:get/get.dart';
import 'package:studiosync/shared/controllers/tabs_controller.dart';

class TraineeTabsBinding extends Bindings {
  @override
  void dependencies() {
    // general dep
    Get.put(GeneralTabController([
      'Profile',
      'Workouts',
      'Sessions',
    ]));
    
    //spetsific tabs dep
    _bindProfileTab();
  }

  void _bindProfileTab() {}
}
