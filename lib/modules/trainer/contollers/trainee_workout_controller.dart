import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/modules/trainee/models/scope_model.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/services/trainee_profile_service.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/add_workout_buttom.dart';
import 'package:uuid/uuid.dart';

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

  static const List<String> bodyParts = [
    'Chest',
    'Arms',
    'Legs',
    'Buttocks',
    'Abs'
  ];

  @override
  void onInit() {
    super.onInit();
    _listenToTraineeChanges();
    _listenToWorkoutChanges();
  }

  @override
  void onReady() {
    super.onReady();
    fetchWorkouts();
  }

  //-----------TRAINEE------------
  void _listenToTraineeChanges() {
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
  void _listenToWorkoutChanges() {
    if (trainee.value != null) {
      workoutsDocSubscription = traineeProfileService
          .getWorkoutChanges(trainee.value!.userId) // הנח שיש לך פונקציה כזאת
          .listen((updatedWorkouts) {
        workouts.value = updatedWorkouts; // עדכן את הרשימה המקומית
      });

     
    }
  }

  Future<void> fetchWorkouts() async {
    if (trainee.value != null) {
      final workoutsList =
          await traineeProfileService.fetchWorkouts(trainee.value!.userId);

      // Convert date strings to DateTime objects and sort by date in descending order (latest first)
      workouts.value = workoutsList
        ..sort((a, b) {
          DateTime dateA = DateTime.parse(a.dateScope.toString());
          DateTime dateB = DateTime.parse(b.dateScope.toString());
          return dateB.compareTo(dateA); // Descending order
        });
    }
  }

  void addWorkout() {
    if (!_validateWorkoutInput()) return;

    final newWorkout = _createWorkoutFromInput();
    workouts.add(newWorkout);
    traineeProfileService.addWorkoutToTrainee(
        trainee.value!.userId, newWorkout);

    Get.back();
    Get.snackbar('Success', 'Workout added successfully',
        backgroundColor: Colors.greenAccent, colorText: Colors.white);

    resetControllers();
  }

  void deleteWorkout(WorkoutModel workout) async {
    await traineeProfileService.deleteWorkout(trainee.value!, workout);
    workouts.value = List.from(workouts)..remove(workout);
    workouts.refresh();
  }

  void updateWorkout( WorkoutModel? workout) async {
    List<ScopeModel> scopes = scopeControllers
        .map((controller) => ScopeModel(
              name: bodyParts[scopeControllers.indexOf(controller)],
              size: double.parse(controller.text),
            ))
        .toList();

    final updatedWorkout = workout?.copyWith(
      weight: double.parse(weightController.text),
      listScopes: scopes,
    );

    await traineeProfileService.editWorkoutToFirestore(
        trainee.value!, updatedWorkout!);

    Get.back();
  }

  WorkoutModel _createWorkoutFromInput() {
    List<ScopeModel> scopes = _createScopesFromInput();
    return WorkoutModel(
      id: const Uuid().v4(),
      weight: double.parse(weightController.text),
      listScopes: scopes,
      dateScope: DateTime.now(),
    );
  }

  List<ScopeModel> _createScopesFromInput() {
    return scopeControllers
        .asMap()
        .entries
        .where((entry) => entry.value.text.isNotEmpty)
        .map((entry) => ScopeModel(
              name: bodyParts[entry.key],
              size: double.parse(entry.value.text),
            ))
        .toList();
  }

  bool _validateWorkoutInput() {
    if (weightController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter the weight',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    if (scopeControllers.every((controller) => controller.text.isEmpty)) {
      Get.snackbar('Error', 'Please enter at least one scope',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    return true;
  }

  void showAddWorkoutBottomSheet( WorkoutModel? workout) {
    Get.bottomSheet(
      AddWorkoutBottomSheet(workout: workout, trainee: trainee.value),
      isScrollControlled: true,
    );
    resetControllers();
  }

  void resetControllers() {
    weightController.clear();
    for (var scopeController in scopeControllers) {
      scopeController.clear();
    }
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
    workouts.sort((a, b) => a.dateScope.compareTo(b.dateScope));

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
