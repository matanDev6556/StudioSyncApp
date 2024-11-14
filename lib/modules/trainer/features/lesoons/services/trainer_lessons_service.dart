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

  Future<List<TraineeModel>> getRegisteredTrainees(
      String trainerId, List<String> traineeIds) async {
    final List<TraineeModel> registeredTrainees = [];

    for (final traineeId in traineeIds) {
      final traineeDoc = await firestoreService.firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('trainees')
          .doc(traineeId)
          .get();

      if (traineeDoc.exists) {
        final traineeData = traineeDoc.data();
        if (traineeData != null) {
          final trainee = TraineeModel.fromJson(traineeData);
          registeredTrainees.add(trainee);
        }
      }
    }

    return registeredTrainees;
  }

  Future<void> addLesson(String trainerId, LessonModel lesson) async {
    try {
      final lessonsRef = firestoreService.firestore
          .collection('trainers')
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
          .collection('trainers')
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
          .collection('trainers')
          .doc(trainerId)
          .collection('lessons')
          .doc(lessonId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete lesson: $e');
    }
  }

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

  Future<void> updateTraineeSub(TraineeModel traineeModel) async {
    await firestoreService.updateDocument(
      'trainers/${traineeModel.trainerID}/trainees}',
      traineeModel.userId,
      traineeModel.toMap(),
    );
  }
}
