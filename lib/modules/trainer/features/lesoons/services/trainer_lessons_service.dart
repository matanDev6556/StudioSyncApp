import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

class TrainerLessonsService {
  final FirestoreService firestoreService;

  TrainerLessonsService(this.firestoreService);

  // Listen to changes in the lessons collection for a specific trainer
  Stream<List<LessonModel>> getLessonChanges(String trainerID) {
    return firestoreService.firestore
        .collection('users')
        .doc(trainerID)
        .collection('lessons')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return LessonModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<List<TraineeModel>> getTraineesByIds(List<String> traineeIds) async {
    // כאן תבצע שאילתא על Firestore כדי להביא את המתאמנים לפי ה־IDs שלהם
    final snapshots = await firestoreService.firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: traineeIds)
        .get();

    return snapshots.docs
        .map((doc) => TraineeModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> addLesson(String trainerId, LessonModel lesson) async {
    try {
      final lessonsRef = firestoreService.firestore
          .collection('users')
          .doc(trainerId)
          .collection('lessons')
          .doc(lesson.id);

      await lessonsRef.set(lesson.toJson());
    } catch (e) {
      throw Exception("Failed to add lesson: $e");
    }
  }

  Future<void> updateLesson(String trainerId, LessonModel lesson) async {
    try {
      // גישה ל-subcollection של השיעורים עבור המאמן
      final lessonsRef = firestoreService.firestore
          .collection('users')
          .doc(trainerId)
          .collection('lessons')
          .doc(lesson.id);

      await lessonsRef.update(lesson.toJson());
    } catch (e) {
      throw Exception("Failed to update lesson: $e");
    }
  }

  Future<void> deleteLesson(String trainerId, String lessonId) async {
    try {
      await firestoreService.firestore
          .collection('users')
          .doc(trainerId)
          .collection('lessons')
          .doc(lessonId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete lesson: $e');
    }
  }

  
}
