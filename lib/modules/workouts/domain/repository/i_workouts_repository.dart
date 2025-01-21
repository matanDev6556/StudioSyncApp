import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/workouts/data/model/workout_model.dart';

abstract class IWorkoutRepository {
  Stream<List<WorkoutModel>> streamWorkoutChanges(
      String trainerId, String traineeId);

  Future<List<WorkoutModel>> fetchWorkouts(String trainerId, String traineeId);

  Future<void> addWorkoutToTrainee(
      String trainerId, String traineeId, WorkoutModel workout);

  Future<void> editWorkoutToFirestore(
      String trainerId, String traineeId, WorkoutModel workout);
      
  Future<void> deleteWorkout(
      String trainerId, TraineeModel trainee, WorkoutModel workout);
}
