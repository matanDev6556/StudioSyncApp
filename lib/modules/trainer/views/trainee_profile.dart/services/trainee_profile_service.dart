import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';

class TraineeProfileService {
  final FirestoreService firestoreService;

  TraineeProfileService(this.firestoreService);

  Stream<TraineeModel> getTraineeChanges(String userId) {
    return firestoreService.firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return TraineeModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Trainee not found');
      }
    });
  }

  Future<void> addWorkoutToTrainee(
      String traineeId, WorkoutModel workout) async {
    await firestoreService.firestore
        .collection('users')
        .doc(traineeId)
        .collection('workouts')
        .add(workout.toMap());
  }

   Future<List<WorkoutModel>> fetchWorkouts(String traineeId) async {
    try {
      final workoutCollection = await firestoreService.firestore
          .collection('users')
          .doc(traineeId)
          .collection('workouts')
          .get();

      return workoutCollection.docs
          .map((doc) => WorkoutModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Failed to fetch workouts: $e');
      return [];
    }
  }

  Stream<List<WorkoutModel>> getWorkoutChanges(String userId) {
   
    return firestoreService.firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkoutModel.fromJson(doc.data()))
            .toList());
  }
}

