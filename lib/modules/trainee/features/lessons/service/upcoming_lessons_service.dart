import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

class UpcomingLessonsTraineeService {
  final FirestoreService firestoreService;

  UpcomingLessonsTraineeService({required this.firestoreService});

    Stream<List<LessonModel>> getUpcomingRegisteredLessonsForTrainee(
      String trainerId, String traineeId) {

    String collectionPath = 'trainers/$trainerId/lessons';

    
    Query query = firestoreService.firestore
        .collection(collectionPath)
        .where('traineesRegistrations', arrayContains: traineeId);

    
    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return LessonModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
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
