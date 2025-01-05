import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/data/models/workout_model.dart';

abstract class IWorkoutsRepository {
  Future<List<WorkoutModel>> fetchWorkouts(String trainerId, String traineeId);
  Stream<List<WorkoutModel>> getWorkoutChanges(String trainerId, String traineeId);
}