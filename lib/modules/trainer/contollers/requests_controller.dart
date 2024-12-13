import 'dart:async';

import 'package:get/get.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainees_controller.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/shared/models/request_model.dart';

class RequestsController extends GetxController {
  final FirestoreService firestoreService;
  RequestsController({required this.firestoreService});

  RxList<TraineeModel> traineesRequests = <TraineeModel>[].obs;
  final String trainerId =
      Get.find<TrainerController>().trainer.value?.userId ?? '';
  final RxBool isLoading = false.obs;

  late StreamSubscription requestStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    listenToRequests();
  }

  @override
  void onClose() {
    requestStreamSubscription.cancel();
  }

  void listenToRequests() {
    requestStreamSubscription = firestoreService
        .streamCollection('trainers/$trainerId/requests')
        .listen((snapshot) {
      traineesRequests.clear();

      for (var doc in snapshot.docs) {
        _processRequest(doc.data());
      }
    }, onError: (error) {
      print("Error listening to requests: $error");
    });
  }

  Future<void> _processRequest(Map<String, dynamic> requestData) async {
    final request = RequestModel.fromMap(requestData);
    final traineeData =
        await firestoreService.getDocument('trainees', request.traineeID);

    if (traineeData != null) {
      traineesRequests.add(TraineeModel.fromJson(traineeData));
    }
  }

  Future<void> approveTraineeRequest(TraineeModel trainee) async {
    final traineesController = Get.find<TraineesController>();

    isLoading.value = true;
    final updatedTrainee = trainee.copyWith(
      trainerID: trainerId,
      startWorkOutDate: DateTime.now(),
    );

    try {
      await _addTraineeToTrainer(updatedTrainee);
      await _removeTraineeFromGeneralCollection(trainee.userId);
      await _updateAllTraineesCollection(trainee.userId);
      await _removeRequestFromFirebase(trainee.userId);

      traineesRequests.removeWhere((t) => t.userId == trainee.userId);
      traineesController.addTraineeToList(updatedTrainee);
    } catch (e) {
      print("Error approving trainee request: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectTraineeRequest(TraineeModel trainee) async {
    isLoading.value = true;
    try {
      await _removeRequestFromFirebase(trainee.userId);
      traineesRequests.removeWhere((t) => t.userId == trainee.userId);
    } catch (e) {
      print("Error rejecting trainee request: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _addTraineeToTrainer(TraineeModel trainee) async {
    await firestoreService.setDocument(
      'trainers/$trainerId/trainees',
      trainee.userId,
      trainee.toMap(),
    );
  }

  Future<void> _removeTraineeFromGeneralCollection(String userId) async {
    await firestoreService.deleteDocument('trainees', userId);
  }

  Future<void> _updateAllTraineesCollection(String userId) async {
    await firestoreService.setDocument(
      'AllTrainees',
      userId,
      {'id': userId, 'trainerID': trainerId},
    );
  }

  Future<void> _removeRequestFromFirebase(String userId) async {
    await firestoreService.deleteDocumentsWithFilters(
      'trainers/$trainerId/requests',
      {'traineeID': userId},
    );
  }
}
