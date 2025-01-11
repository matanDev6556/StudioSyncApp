import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studiosync/core/data/data_source/firebase/firestore_service.dart';
import 'package:studiosync/core/domain/repositories/i_lessons_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';
import 'package:studiosync/modules/trainer/models/lessons_settings_model.dart';

class FirebaseLessonsRepository implements ILessonsRepository {
  final FirestoreService _firestoreService;

  FirebaseLessonsRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  // --TRAINER--

  @override
  Future<List<TraineeModel>> getRegisteredTraineesOfLesson(
      String trainerId, List<String> traineeIds) async {
    final List<TraineeModel> registeredTrainees = [];

    for (final traineeId in traineeIds) {
      final traineeData = await _firestoreService.getDocument(
        'trainers/$trainerId/trainees',
        traineeId,
      );

      if (traineeData != null) {
        final trainee = TraineeModel.fromJson(traineeData);
        registeredTrainees.add(trainee);
      }
    }

    return registeredTrainees;
  }

  @override
  Future<void> addLesson(String trainerId, LessonModel lesson) async {
    try {
      await _firestoreService.setDocument(
          'trainers/$trainerId/lessons', lesson.id, lesson.toJson());
    } catch (e) {
      throw Exception("Failed to add lesson: $e");
    }
  }

  @override
  Future<void> updateLesson(String trainerId, LessonModel lesson) async {
    try {
      final lessonsRef = _firestoreService.firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('lessons')
          .doc(lesson.id);

      await lessonsRef.update(lesson.toJson());
    } catch (e) {
      throw Exception("Failed to update lesson: $e");
    }
  }

  @override
  Future<void> deleteLesson(String trainerId, String lessonId) async {
    try {
      await _firestoreService.deleteDocument(
          'trainers/$trainerId/lessons', lessonId);
    } catch (e) {
      throw Exception('Failed to delete lesson: $e');
    }
  }

  @override
  Future<LessonsSettingsModel> getSettingsLessons(String trainerId) async {
    final settingsMap = await _firestoreService.getDocument(
        'trainers/$trainerId/settings', 'lessonsSettings');

    return LessonsSettingsModel.fromMap(settingsMap!);
  }

  @override
  Future<void> updateSettingsLessons(
      String trainerId, LessonsSettingsModel lessonsSettingsModel) async {
    await _firestoreService.setDocument('trainers/$trainerId/settings',
        'lessonsSettings', lessonsSettingsModel.toMap());
  }
  // --TRAINEE--

  @override
  Future<void> addTraineeToLesson(
      TraineeModel traineeModel, String lessonId) async {
    DocumentReference lessonRef = _firestoreService.firestore
        .collection('trainers')
        .doc(traineeModel.trainerID)
        .collection('lessons')
        .doc(lessonId);

    await lessonRef.update({
      'traineesRegistrations': FieldValue.arrayUnion([traineeModel.userId])
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

  @override
  Stream<List<LessonModel>> streamRegisteredTraineeLessons(
      String trainerId, String traineeId) {
    String collectionPath = 'trainers/$trainerId/lessons';

    Query query = _firestoreService.firestore
        .collection(collectionPath)
        .where('traineesRegistrations', arrayContains: traineeId);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return LessonModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // --COMMON--

  @override
  Stream<List<LessonModel>> streamLessons(String trainerId) {
    return _firestoreService
        .streamCollection('trainers/$trainerId/lessons')
        .map((snap) {
      return snap.docs.map((doc) => LessonModel.fromJson(doc.data())).toList();
    });
  }

  @override
  Stream<LessonsSettingsModel?> streamLessonsSettings(String trainerId) {
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
}
