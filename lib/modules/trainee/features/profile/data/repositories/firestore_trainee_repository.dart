import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/itrainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class FirestoreTraineeRepository implements ITraineeRepository {
  final FirestoreService _firestoreService;

  FirestoreTraineeRepository(this._firestoreService);

  @override
  Stream<TraineeModel> listenToTraineeUpdates(String path) {
    return _firestoreService.streamDocument(path).map((snapshot) {
      if (snapshot.exists) {
        return TraineeModel.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception("Document does not exist at path: $path");
      }
    });
  }

  @override
  Future<void> saveTrainee(TraineeModel trainee, String path) async {
    await _firestoreService.setDocument(
      path,
      trainee.userId,
      trainee.toMap(),
    );
  }

  @override
  Future<void> updateProfileImage(TraineeModel trainee, String path) async {
    saveTrainee(trainee, path);
  }
}
