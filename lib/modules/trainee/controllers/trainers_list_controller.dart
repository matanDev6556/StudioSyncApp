import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/views/widgets/filters_buttom.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class TrainersListController extends GetxController {
  final FirestoreService firestoreService;
  TrainersListController({required this.firestoreService});

  RxList<TrainerModel> trainers = <TrainerModel>[].obs;
  var isLoading = false.obs;

  // Filters
  RxList<TrainerModel> filteredTrainers = <TrainerModel>[].obs;
  RxList<String> lessonsFilter = <String>[].obs;
  RxBool inMyCity = false.obs;
  RxBool markedFilters = false.obs;

  @override
  void onInit() async {
    super.onInit();

    await _loadPreferences();
  }

  Future<void> fetchTrainers() async {
    isLoading.value = true;

    final trainersMap = await firestoreService.getCollectionWithFilters(
      'trainers',
      {
        if (inMyCity.value) 'userCity': _getUserCity(),
      },
    );

    trainers.value = trainersMap.map((e) => TrainerModel.fromJson(e)).toList();
    applyFilters();

    isLoading.value = false;
  }

  void _onFilterSelected(bool selectedInMyCity, List<String> selectedLessons) {
    inMyCity.value = selectedInMyCity;
    lessonsFilter.assignAll(selectedLessons);
    markedFilters.value = true;
    _savePreferences();
    fetchTrainers();
  }

  void removeFilter(String filter) {
    lessonsFilter.remove(filter);
    _savePreferences();
  }

  void showFilterBottomSheet() {
    // Show the BottomSheet to choose preferences
    Get.bottomSheet(
      // Add BottomSheet UI here for filtering options
      FilterBottomSheet(onFilterSelected: _onFilterSelected),
    );
  }

  void applyFilters() {
    if (lessonsFilter.isEmpty) {
      filteredTrainers.value = trainers;
    } else {
      filteredTrainers.value = trainers.where((trainer) {
        return lessonsFilter
            .any((lesson) => trainer.lessonsTypeList.contains(lesson));
      }).toList();
    }

    filteredTrainers.refresh();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    inMyCity.value = prefs.getBool('inMyCity') ?? false;
    markedFilters.value = prefs.getBool('markedFilters') ?? false;
    lessonsFilter.assignAll(prefs.getStringList('lessonsFilter') ?? []);
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('inMyCity', inMyCity.value);
    await prefs.setStringList('lessonsFilter', lessonsFilter);
    await prefs.setBool('markedFilters', markedFilters.value);
  }

  String _getUserCity() {
    return Get.find<TraineeController>().trainee.value?.userCity ?? '';
  }
}
