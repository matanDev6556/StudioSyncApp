import 'package:get/get.dart';

class GeneralTabController extends GetxController {
  final List<String> tabs;
  RxInt selectedIndex = 0.obs;

  GeneralTabController(this.tabs);

  void updateIndex(int index) {
    if (index >= 0 && index < tabs.length) {
      selectedIndex.value = index;
    }
  }
}