import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/data/model/trainer_filter_model.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/domain/usecases/fetch_trainers_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/domain/usecases/filter_trainers_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/domain/usecases/load_prefrences_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/domain/usecases/save_preference_usecase.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/utils/keys_filters_prefrences.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/presentation/widgets/filters_trainrs_buttom.dart';
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
  RxString errorMessage = ''.obs;

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
    if (!filters.value.markedFilters) {
      showFilterBottomSheet();
    } else {
      if (trainers.isNotEmpty) return;
      fetchTrainers();
    }
  }

// Update fetchTrainers
  Future<void> fetchTrainers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final userCity = filters.value.inMyCity
          ? _traineeController.trainee.value?.userCity ?? ''
          : '';

      trainers.value = await _fetchTrainersUseCase.execute(userCity);
      applyFilters();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //--FILTERS--
  void removeFilter(String filter) {
    filters.value.lessonsFilter.remove(filter);
    filters.refresh();
    _savePreferences(
        PreferencesKeys.lessonFilters, filters.value.lessonsFilter);
    applyFilters();
  }

  void setIsInMyCity(bool val) {
    filters.value.inMyCity = val;
    filters.refresh();

    _savePreferences(PreferencesKeys.inMyCity, val);
    fetchTrainers();
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

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
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
    filters.value = TrainerFilters.fromMap(prefs);
  }

  Future<void> _savePreferences(String key, dynamic value) async {
    await _savePreferencesUseCase.execute(key: key, value: value);
  }
}
