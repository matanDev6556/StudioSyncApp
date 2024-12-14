import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/services/trainees_service.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/services/trainess_filter_service.dart';

class TraineesController extends GetxController {
  final TraineeListService traineeService;
  final TraineeFilterService filterService;

  final IAuthRepository authService;

  RxList<TraineeModel> traineesList = <TraineeModel>[].obs;
  RxList<TraineeModel> filteredTraineesList = <TraineeModel>[].obs;
  RxBool isLoading = false.obs;

  // Search query and filter state
  RxString searchQuery = ''.obs;
  RxString activeStatusFilter = 'All'.obs;

  TraineesController(
    this.authService,
    this.traineeService,
    this.filterService,
  );

  @override
  void onInit() {
    super.onInit();
    fetchTrainees();
    // Set up a listener to filter the list whenever searchQuery or activeStatusFilter changes
    debounce(searchQuery, (_) => applyFilters(),
        time: const Duration(milliseconds: 300));
    ever(activeStatusFilter, (_) => applyFilters());
  }

  Future<void> fetchTrainees() async {
    try {
      print('fetch trainees');
      final uid = authService.currentUser?.uid;
     
      isLoading.value = true;

      // Fetch the trainees from the service
      final trainees = await traineeService.getTraineesForTrainer(uid!);

      // Update the trainees list
      traineesList.value = trainees;
      traineesList.refresh();

      // Apply filters after fetching the data
      applyFilters();
    } catch (e) {
      print('Error fetching trainees: $e');
    } finally {
      isLoading.value = false;
    }
  }
  void addTraineeToList(TraineeModel trainee) {
    traineesList.add(trainee);
    traineesList.refresh();
    applyFilters();
  }

  // Update the search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Update the active status filter
  void updateActiveStatusFilter(String? status) {
    if (status != null) {
      activeStatusFilter.value = status;
    }
  }

  // Apply filters using the filter service
  void applyFilters() {
    filteredTraineesList.value = filterService.filterTrainees(
      traineesList: traineesList,
      searchQuery: searchQuery.value,
      activeStatusFilter: activeStatusFilter.value,
    );
  }
}
