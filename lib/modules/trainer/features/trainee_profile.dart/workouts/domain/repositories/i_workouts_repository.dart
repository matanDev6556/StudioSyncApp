import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/core/data/models/workout_model.dart';

abstract class IWorkoutRepository {

  Future<List<WorkoutModel>> fetchWorkouts(String trainerId, String traineeId);

  Future<void> addWorkoutToTrainee(
      String trainerId, String traineeId, WorkoutModel workout);

  Future<void> editWorkoutToFirestore(
      String trainerId, String traineeId, WorkoutModel workout);

  Future<void> deleteWorkout(
      String trainerId, TraineeModel trainee, WorkoutModel workout);
}
