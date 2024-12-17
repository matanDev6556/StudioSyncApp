import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/lessons/domain/repositories/i_registredLessons_repository.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

class RegistredTraineeLessonsFirestoreRepository
    implements IRegistredLessonsRepository {
  final FirestoreService _firestoreService;

  RegistredTraineeLessonsFirestoreRepository(
      {required FirestoreService firestoreService})
      : _firestoreService = firestoreService;
  @override
  Stream<List<LessonModel>> getRegisteredLessons(
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
}
