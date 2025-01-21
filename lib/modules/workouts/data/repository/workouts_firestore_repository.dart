import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studiosync/core/data/data_source/firebase/firestore_service.dart';
import 'package:studiosync/modules/workouts/domain/repository/i_workouts_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/workouts/data/model/workout_model.dart';

class FirestoreWorkoutsRepository implements IWorkoutRepository {
  final FirestoreService _firestoreService;

  FirestoreWorkoutsRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

    @override
  Stream<List<WorkoutModel>> streamWorkoutChanges(
      String trainerId, String traineeId) {
    return _firestoreService
        .streamCollection('trainers/$trainerId/trainees/$traineeId/workouts')
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkoutModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> addWorkoutToTrainee(
      String trainerId, String traineeId, WorkoutModel workout) async {
    await _firestoreService.setDocument(
        'trainers/$trainerId/trainees/$traineeId/workouts',
        workout.id,
        workout.toMap());
  }

  @override
  Future<void> deleteWorkout(
      String trainerId, TraineeModel trainee, WorkoutModel workout) async {
    await _firestoreService.deleteDocumentsWithFilters(
        'trainers/$trainerId/trainees/${trainee.userId}/workouts',
        {'id': workout.id});
  }

  @override
  Future<void> editWorkoutToFirestore(
      String trainerId, String traineeId, WorkoutModel workout) async {
    await _firestoreService.firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('trainees')
        .doc(traineeId)
        .collection('workouts')
        .where('id', isEqualTo: workout.id)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.set(workout.toMap(), SetOptions(merge: true));
      }
    });
  }

  @override
  Future<List<WorkoutModel>> fetchWorkouts(
      String trainerId, String traineeId) async {
    final workoutCollection = await _firestoreService
        .getCollection('trainers/$trainerId/trainees/$traineeId/workouts');

    return workoutCollection.map((doc) => WorkoutModel.fromJson(doc)).toList();
  }

}
