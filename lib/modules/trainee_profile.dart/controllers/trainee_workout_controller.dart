import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class TraineeWorkoutController extends GetxController {
  final Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);
  late StreamSubscription<DocumentSnapshot> traineeDocSubscription;


  TraineeWorkoutController({required TraineeModel initialTrainee}) {
    trainee.value = initialTrainee;
  }

  @override
  void onInit() {
    super.onInit();
    
    trainee.value = Get.arguments as TraineeModel;
    listenToTraineeChanges();
  }


  void listenToTraineeChanges() {
    traineeDocSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(trainee.value!.userId)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        trainee.value =
            TraineeModel.fromJson(event.data() as Map<String, dynamic>);
        updateLocalTrainee(trainee.value!);
      }
    });
  }

  String getFormattedStartDate() {
    return trainee.value?.startWorOutDate != null
        ? DateFormat('yMMMMd').format(trainee.value!.startWorOutDate!)
        : 'Not start yet';
  }

  void deleteTrainee() {
    // Implement delete logic here
  }

  void updateLocalTrainee(TraineeModel updatedTrainee) {
    trainee.value = updatedTrainee;
    trainee.refresh();
  }

  @override
  void onClose() {
    traineeDocSubscription.cancel();
    super.onClose();
  }
}
