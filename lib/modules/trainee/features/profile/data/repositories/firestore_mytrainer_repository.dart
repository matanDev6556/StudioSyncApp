import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_mytrainer_repository.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class MyTrainerFirestoreRepository implements IMyTrainerRepositroy {
  final FirestoreService _firestoreService;

  MyTrainerFirestoreRepository(this._firestoreService);

  @override
  Future<void> disconnectedTrainer(
      TraineeModel traineeModel, String trainerID) async {
    // move the trainee doc to general trainees coll
    await _firestoreService.setDocument(
        'trainees', traineeModel.userId, traineeModel.toMap());

    // remove all the trqainee date from the trainer
    await _firestoreService.deleteDocumentAndSubcollections(
      'trainers/$trainerID/trainees',
      traineeModel.userId,
      ['workouts'],
    );

    //update the trainer ID to empty
    await _firestoreService.setDocument('AllTrainees', traineeModel.userId, {
      'trainerID': '',
    });
  }

  @override
  Future<TrainerModel?> fetchMyTrainer(String trainerID) async {
    final trainerMap =
        await _firestoreService.getDocument('trainers', trainerID);

    if (trainerMap != null) {
      return TrainerModel.fromJson(trainerMap);
    }
    return null;
  }
}
