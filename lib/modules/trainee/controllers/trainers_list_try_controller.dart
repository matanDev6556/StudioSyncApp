import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/model/trainer_filter_model.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/fetch_trainers_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/filter_trainers_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/load_prefrences_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/usecases/save_preference_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/utils/keys_filters_prefrences.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/widgets/filters_trainrs_buttom.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class TrainersListController extends GetxController {
  final FetchTrainersUseCase _fetchTrainersUseCase;
  final LoadPreferencesUseCase _loadPreferencesUseCase;
  final SavePreferencesUseCase _savePreferencesUseCase;
  final FilterTrainersUseCase _filterTrainersUseCase;

  final TraineeController _traineeController = Get.find<TraineeController>();

  TrainersListController(
    this._fetchTrainersUseCase,
    this._loadPreferencesUseCase,
    this._savePreferencesUseCase,
    this._filterTrainersUseCase,
  );

  RxList<TrainerModel> trainers = <TrainerModel>[].obs;
  var isLoading = false.obs;

  // Filters
  RxList<TrainerModel> filteredTrainers = <TrainerModel>[].obs;
  Rx<TrainerFilters> filters = TrainerFilters(
    inMyCity: false,
    markedFilters: false,
    lessonsFilter: [],
  ).obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await loadPreferences();
  }

  Future<void> fetchTrainers() async {
    isLoading.value = true;
    final userCity = filters.value.inMyCity
        ? _traineeController.trainee.value?.userCity ?? ''
        : '';

    trainers.value = await _fetchTrainersUseCase.execute(userCity);

    applyFilters();

    isLoading.value = false;
  }

  //--FILTERS--
  void removeFilter(String filter) {
    filters.value.lessonsFilter.remove(filter);
    filters.refresh();
    _savePreferences(
        PreferencesKeys.lessonFilters, filters.value.lessonsFilter);
  }

  void setIsInMyCity(bool val) {
    filters.value.inMyCity = val;
    filters.refresh();
    _savePreferences(PreferencesKeys.inMyCity, val);
  }

  void _onFilterSelected(bool selectedInMyCity, List<String> selectedLessons) {
    setIsInMyCity(selectedInMyCity);

    filters.value.lessonsFilter.assignAll(selectedLessons);
    filters.value.markedFilters = true;

    _savePreferences(
        PreferencesKeys.lessonFilters, filters.value.lessonsFilter);
    _savePreferences(PreferencesKeys.markedFilters, true);

    fetchTrainers();
  }

  void applyFilters() {
    filteredTrainers.value = _filterTrainersUseCase.execute(
      trainers: trainers,
      lessonsTypesFilter: filters.value.lessonsFilter,
      searchQuery: searchQuery.value,
    );
    filteredTrainers.refresh();
  }

  // --UI--
  void showFilterBottomSheet() {
    // Show the BottomSheet to choose preferences
    Get.bottomSheet(
      FilterTrainersBottomSheet(onFilterSelected: _onFilterSelected),
    );
  }

  //--- PREFERENCES---

  Future<void> loadPreferences() async {
    final prefs = await _loadPreferencesUseCase.execute();
    print(prefs);
    filters.value = TrainerFilters.fromMap(prefs);
  }

  Future<void> _savePreferences(String key, dynamic value) async {
    print('$key: $value');
    await _savePreferencesUseCase.execute(key: key, value: value);
  }
}
