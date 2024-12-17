import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_lessons_trainee_repository.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/models/lessons_settings_model.dart';

class LessonsTraineeRepsitory implements ILessonsTraineeRepository {
  final FirestoreService _firestoreService;

  LessonsTraineeRepsitory({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;
  @override
  Future<void> addTraineeToLesson(
      String trainerId, String lessonId, String traineeId) async {
    DocumentReference lessonRef = _firestoreService.firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('lessons')
        .doc(lessonId);

    await lessonRef.update({
      'traineesRegistrations': FieldValue.arrayUnion([traineeId])
    });
  }

  @override
  Stream<LessonsSettingsModel?> getLessonsSettings(String trainerId) {
    return _firestoreService
        .streamDocument('trainers/$trainerId/settings/lessonsSettings')
        .map((snapshot) {
      if (snapshot.exists) {
        return LessonsSettingsModel.fromMap(
            snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  @override
  Stream<List<LessonModel>> getUpcomingLessons(String trainerId) {
    return _firestoreService
        .streamCollection('trainers/$trainerId/lessons')
        .map((snap) {
      return snap.docs.map((doc) => LessonModel.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<void> removeTraineeFromLesson(
      String trainerId, String lessonId, String traineeId) async {
    DocumentReference lessonRef = _firestoreService.firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('lessons')
        .doc(lessonId);

    await lessonRef.update({
      'traineesRegistrations': FieldValue.arrayRemove([traineeId])
    });

   
  }
}
