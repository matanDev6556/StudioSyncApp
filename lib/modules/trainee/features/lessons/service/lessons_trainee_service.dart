import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

class LessonsTraineeService {
  final FirestoreService firestoreService;

  LessonsTraineeService({required this.firestoreService});

  // Listen to changes in the lessons collection for a specific trainer
  // Listen to changes in the lessons collection for a specific trainer
  Stream<List<LessonModel>> getUpcomingLessonChanges(String trainerID) {
    return firestoreService.firestore
        .collection('trainers')
        .doc(trainerID)
        .collection('lessons')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return LessonModel.fromJson(doc.data());
      }).toList();
    });
  }
  
  Stream<DocumentSnapshot<Map<String, dynamic>>?> getLessonsSettingsChanges(String trainerID) {
    return firestoreService
        .streamDocument('trainers/$trainerID/settings/lessonsSettings');
  }

  Future<void> addTraineeToLesson(
      String trainerId, String lessonId, String traineeId) async {
    try {
      DocumentReference lessonRef = firestoreService.firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('lessons')
          .doc(lessonId);

      await lessonRef.update({
        'traineesRegistrations': FieldValue.arrayUnion([traineeId])
      });

      print("Trainee added successfully.");
    } catch (e) {
      print("Error adding trainee: $e");
      // טיפול בשגיאה
    }
  }

  // פונקציה להסרת מתאמן משיעור
  Future<void> removeTraineeFromLesson(
      String trainerId, String lessonId, String traineeId) async {
    try {
      DocumentReference lessonRef = firestoreService.firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('lessons')
          .doc(lessonId);

      await lessonRef.update({
        'traineesRegistrations': FieldValue.arrayRemove([traineeId])
      });

      print("Trainee removed successfully.");
    } catch (e) {
      print("Error removing trainee: $e");
      // טיפול בשגיאה
    }
  }
}
