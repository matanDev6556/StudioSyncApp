import 'dart:async';
import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/workouts/services/workouts_service.dart';
import 'package:studiosync/modules/trainee/models/subscriptions/subscription_model.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';
import 'package:studiosync/shared/models/workout_summary.dart';
import 'package:studiosync/shared/services/workouts_analytics_service.dart';

class WorkoutController extends GetxController {
  final WorkoutsService workoutsService;

  final TraineeController traineeController = Get.find();

  WorkoutController({required this.workoutsService});

  RxList<WorkoutModel> workouts = <WorkoutModel>[].obs;
  late StreamSubscription<List<WorkoutModel>> workoutsDocSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToWorkoutChanges();
  }

  Rx<Subscription?> getSubscription() =>
      Rx<Subscription?>(traineeController.trainee.value?.subscription);
  Rx<TraineeModel?> get trainee =>
      Rx<TraineeModel?>(traineeController.trainee.value);

  void _listenToWorkoutChanges() {
    workoutsDocSubscription = workoutsService
        .getWorkoutChanges(traineeController.trainee.value!.trainerID,
            traineeController.trainee.value!.userId)
        .listen((updatedWorkouts) {
      workouts.assignAll(_filterAndSortWorkoutsByDate(updatedWorkouts));
    });
  }

  Future<void> fetchWorkouts() async {
    if (traineeController.trainee.value != null) {
      final workoutsList = await workoutsService.fetchWorkouts(
          traineeController.trainee.value!.trainerID,
          traineeController.trainee.value!.userId);

      workouts.assignAll(_filterAndSortWorkoutsByDate(workoutsList));
    }
  }

  List<WorkoutModel> _filterAndSortWorkoutsByDate(
      List<WorkoutModel> workoutsList) {
    return workoutsList
      ..sort((a, b) {
        DateTime dateA = DateTime.parse(a.dateScope.toString());
        DateTime dateB = DateTime.parse(b.dateScope.toString());
        return dateB.compareTo(dateA);
      });
  }

  Rx<WorkoutSummary> get workoutSummary =>
      Rx<WorkoutSummary>(WorkoutAnalytics.computeWorkoutSummary(workouts));

  @override
  void onClose() {
    workoutsDocSubscription.cancel();
    super.onClose();
  }
}
