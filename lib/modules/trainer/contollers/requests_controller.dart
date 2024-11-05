import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/shared/models/request_model.dart';

class RequestsController extends GetxController {
  final FirestoreService firestoreService;
  RequestsController({required this.firestoreService});

  RxList<TraineeModel> traineesRequests = <TraineeModel>[].obs;

  final trainerId = Get.find<TrainerController>().trainer.value?.userId ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      final requestsData =
          await firestoreService.getCollection('trainers/$trainerId/requests');
      for (var reqData in requestsData) {
      
        final req = RequestModel.fromMap(reqData);

        // get the trainee
        final traineeData =
            await firestoreService.getDocument('trainees', req.traineeID);

        if (traineeData != null) {
          final trainee = TraineeModel.fromJson(traineeData);
          traineesRequests.add(trainee);
        }
      }
    } catch (e) {
      // Handle error (e.g., log error or show message)
      print("Error fetching requests: $e");
    }
  }
}
