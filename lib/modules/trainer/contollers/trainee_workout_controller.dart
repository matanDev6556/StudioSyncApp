import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/modules/trainee/models/scope_model.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';
import 'package:studiosync/modules/trainer/views/trainee_profile.dart/services/trainee_profile_service.dart';
import 'package:studiosync/modules/trainer/views/trainee_profile.dart/widgets/add_workout_buttom.dart';

class TraineeWorkoutController extends GetxController {
  final TraineeProfileService traineeProfileService;

  TraineeWorkoutController({
    required TraineeModel initialTrainee,
    required this.traineeProfileService,
  }) {
    trainee.value = initialTrainee;
  }

  final Rx<TraineeModel?> trainee = Rx<TraineeModel?>(null);
  RxList<WorkoutModel> workouts = <WorkoutModel>[].obs;
  late StreamSubscription<TraineeModel> traineeDocSubscription;
  late StreamSubscription<List<WorkoutModel>> workoutsDocSubscription;

  // Controllers for the new workout form
  final TextEditingController weightController = TextEditingController();
  final List<TextEditingController> scopeControllers =
      List.generate(5, (_) => TextEditingController());

  @override
  void onInit() {
    super.onInit();
    listenToTraineeChanges();
    listenToWorkoutChanges();
  }

  @override
  void onReady() {
    super.onReady();
    fetchWorkouts();
  }

  //-----------TRAINEE------------
  void listenToTraineeChanges() {
    if (trainee.value != null) {
      traineeDocSubscription = traineeProfileService
          .getTraineeChanges(trainee.value!.userId)
          .listen((updatedTrainee) {
        trainee.value = updatedTrainee;
        updateLocalTrainee(updatedTrainee);
      });
    }
  }

    void deleteTrainee() {
    // Implement delete logic here
  }

  void updateLocalTrainee(TraineeModel updatedTrainee) {
    trainee.value = updatedTrainee;
    trainee.refresh();
  }


    //-----------WORKOUTS------------
  void listenToWorkoutChanges() {
    if (trainee.value != null) {
      workoutsDocSubscription = traineeProfileService
          .getWorkoutChanges(trainee.value!.userId) // הנח שיש לך פונקציה כזאת
          .listen((updatedWorkouts) {
        workouts.value = updatedWorkouts; // עדכן את הרשימה המקומית
        print(
            'Updated workouts: ${workouts.length}'); // להדפיס את מספר האימונים המעודכנים
      });
    }
  }

  Future<void> fetchWorkouts() async {
    if (trainee.value != null) {
      workouts.value =
          await traineeProfileService.fetchWorkouts(trainee.value!.userId);
    }
  }

  void addWorkout() {
    if (weightController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter the weight');
      return;
    }

    List<ScopeModel> scopes = [];
    for (int i = 0; i < scopeControllers.length; i++) {
      if (scopeControllers[i].text.isNotEmpty) {
        scopes.add(ScopeModel(
          name: ['Chest', 'Arms', 'Legs', 'Buttocks', 'Abs'][i],
          size: double.parse(scopeControllers[i].text),
        ));
      }
    }

    if (scopes.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter at least one scope',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final newWorkout = WorkoutModel(
      weight: double.parse(weightController.text),
      listScopes: scopes,
      dateScope: DateTime.now(),
    );

    workouts.add(newWorkout);

    traineeProfileService.addWorkoutToTrainee(
        trainee.value!.userId, newWorkout);

    Get.back(); // Close the bottom sheet
    Get.snackbar(
      'Success',
      'Workout added successfully',
      backgroundColor: Colors.greenAccent,
      colorText: Colors.white,
    );

    // Clear the form
    weightController.clear();
    for (var controller in scopeControllers) {
      controller.clear();
    }
  }

  void showAddWorkoutBottomSheet() {
    Get.bottomSheet(
      AddWorkoutBottomSheet(),
      isScrollControlled: true,
    );
  }

  String getFormattedStartDate() {
    return trainee.value?.startWorOutDate != null
        ? DateFormat('yMMMMd').format(trainee.value!.startWorOutDate!)
        : 'Not start yet';
  }

  String getWeightTrendMessage(List<WorkoutModel> workouts) {
    if (workouts.length < 2) {
      return "Not enough data";
    }

    // סדר את רשימת האימונים לפי התאריך
    workouts.sort((a, b) => a.dateScope!.compareTo(b.dateScope!));

    double initialWeight = workouts.first.weight; // משקל התחלתי
    double latestWeight = workouts.last.weight; // משקל עדכני
    double weightDifference = latestWeight - initialWeight;

    if (latestWeight > initialWeight) {
      return "You've gained ${weightDifference.toStringAsFixed(2)} kg.";
    } else if (latestWeight < initialWeight) {
      return "You've lost ${(-weightDifference).toStringAsFixed(2)} kg.";
    } else {
      return "Your weight remains unchanged.";
    }
  }


  @override
  void onClose() {
    traineeDocSubscription.cancel();
    super.onClose();
  }
}
