import 'package:studiosync/core/data/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/workouts/domain/repositories/i_workouts_trainee_repository.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';

class WorkoutsRepositoryFirestore implements IWorkoutsRepository {
  final FirestoreService firestoreService;

  WorkoutsRepositoryFirestore({required this.firestoreService});

  @override
  Future<List<WorkoutModel>> fetchWorkouts(
      String trainerId, String traineeId) async {
    try {
      final workoutCollection = await firestoreService
          .getCollection('trainers/$trainerId/trainees/$traineeId/workouts');

      return workoutCollection
          .map((map) => WorkoutModel.fromJson(map))
          .toList();
    } catch (e) {
      print('Failed to fetch workouts: $e');
      return [];
    }
  }

  @override
  Stream<List<WorkoutModel>> getWorkoutChanges(
      String trainerId, String traineeId) {
    return firestoreService
        .streamCollection('trainers/$trainerId/trainees/$traineeId/workouts')
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkoutModel.fromJson(doc.data()))
            .toList());
  }
}
