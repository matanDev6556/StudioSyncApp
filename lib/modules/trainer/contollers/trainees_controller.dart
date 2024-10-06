import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:studiosync/core/services/firebase/auth_service.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class TraineesController extends GetxController {
  final FirestoreService firestoreService;
  final AuthService authService;

  RxList<TraineeModel> traineesList = <TraineeModel>[].obs;
  RxBool isLoading = false.obs;

  TraineesController(this.authService, this.firestoreService);

  @override
  void onInit() {
    super.onInit();
    final uid = authService.currentUser?.uid;
    if (uid != null) {
      fetchTrainees(uid);
    }
  }

  Future<void> fetchTrainees(String trainerId) async {
    try {
      isLoading.value = true;

      // Define the filters
      Map<String, dynamic> filters = {
        'trainerID': trainerId,
        // Add any other filters you need
      };

      // Use the getCollectionWithFilters function
      final traineesDocs =
          await firestoreService.getCollectionWithFilters('trainees', filters);

      // Convert the documents to TraineeModel objects and update the list
      traineesList.value =
          traineesDocs.map((doc) => TraineeModel.fromJson(doc)).toList();
    } catch (e) {
      print('Error fetching trainees: $e');
      // Handle error (e.g., show a snackbar)
    } finally {
      isLoading.value = false;
    }
  }
}
