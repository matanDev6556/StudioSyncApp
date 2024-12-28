import 'package:studiosync/core/data/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';
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
  Future<void> saveTrainee(TraineeModel trainee) async {
    final path = trainee.trainerID.isNotEmpty
        ? 'trainers/${trainee.trainerID}/trainees'
        : 'trainees';
    await _firestoreService.setDocument(
      path,
      trainee.userId,
      trainee.toMap(),
    );
  }

  @override
  Future<void> updateProfileImage(TraineeModel trainee) async {
    saveTrainee(trainee);
  }
  
  @override
  Future<TraineeModel?> getTraineeData(String uid)async {
    final traineeMap = await _firestoreService.getDocument('AllTrainees', uid);

    if (traineeMap == null) return null;

    final isConnectedToTrainer = traineeMap['trainerID']?.isNotEmpty ?? false;

    if (isConnectedToTrainer) {
      final traineeWithTrrainer = await _firestoreService.getDocument(
          'trainers/${traineeMap['trainerID']}/trainees', uid);
      return TraineeModel.fromJson(traineeWithTrrainer!);
    }

    final trainee = await _firestoreService.getDocument('trainees', uid);
    return TraineeModel.fromJson(trainee!);
  }


}
