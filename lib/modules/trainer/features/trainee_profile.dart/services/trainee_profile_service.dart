import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';

class TraineeProfileService {
  final FirestoreService firestoreService;

  TraineeProfileService(this.firestoreService);

  Stream<TraineeModel> getTraineeChanges(String trainerId, String traineeId) {
    return firestoreService.firestore
        .collection('trainers') // מאמנים
        .doc(trainerId) // מזהה המאמן
        .collection('trainees') // אוסף המתאמנים בתוך מסמך המאמן
        .doc(traineeId) // מזהה המתאמן
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return TraineeModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('no found');
      }
    });
  }

Future<void> addWorkoutToTrainee(
    String trainerId, String traineeId, WorkoutModel workout) async {
  await firestoreService.firestore
      .collection('trainers')
      .doc(trainerId) 
      .collection('trainees') 
      .doc(traineeId) 
      .collection('workouts') 
      .add(workout.toMap()); 
}

  Future<List<WorkoutModel>> fetchWorkouts(String trainerId, String traineeId) async {
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

 Stream<List<WorkoutModel>> getWorkoutChanges(String trainerId, String traineeId) {
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

 Future<void> deleteWorkout(String trainerId, TraineeModel trainee, WorkoutModel workout) async {
  await firestoreService.firestore
      .collection('trainers') // אוסף המאמנים
      .doc(trainerId) // מזהה המאמן
      .collection('trainees') // אוסף המתאמנים של המאמן
      .doc(trainee.userId) // מזהה המתאמן
      .collection('workouts') // אוסף האימונים של המתאמן
      .where('id', isEqualTo: workout.id) // מציאת האימון על פי מזהה
      .get()
      .then((snapshot) {
    for (DocumentSnapshot doc in snapshot.docs) {
      doc.reference.delete(); // מחיקת כל מסמך שנמצא
    }
  });
}

Future<void> editWorkoutToFirestore(String trainerId, TraineeModel trainee, WorkoutModel updatedWorkout) async {
  try {
    await firestoreService.firestore
        .collection('trainers') // אוסף המאמנים
        .doc(trainerId) // מזהה המאמן
        .collection('trainees') // אוסף המתאמנים של המאמן
        .doc(trainee.userId) // מזהה המתאמן
        .collection('workouts') // אוסף האימונים של המתאמן
        .where('id', isEqualTo: updatedWorkout.id) // מציאת האימון על פי מזהה
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.set(updatedWorkout.toMap(), SetOptions(merge: true)); // עדכון האימון
      }
    });
  } catch (e) {
    throw e; // טיפול בשגיאה במקרה של כישלון
  }
}
}
