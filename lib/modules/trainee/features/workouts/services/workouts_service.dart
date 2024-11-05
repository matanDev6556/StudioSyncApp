import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';

class WorkoutsService {
  final FirestoreService firestoreService;

  WorkoutsService({required this.firestoreService});

  Future<List<WorkoutModel>> fetchWorkouts(
      String trainerId, String traineeId) async {
    try {
      final workoutCollection = await firestoreService.firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('trainees')
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

  Stream<List<WorkoutModel>> getWorkoutChanges(
      String trainerId, String traineeId) {
    return firestoreService.firestore
        .collection('trainers') // אוסף המאמנים
        .doc(trainerId) // מזהה המאמן
        .collection('trainees') // אוסף המתאמנים של המאמן
        .doc(traineeId) // מזהה המתאמן
        .collection('workouts') // אוסף האימונים של המתאמן
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkoutModel.fromJson(doc.data()))
            .toList());
  }
}
