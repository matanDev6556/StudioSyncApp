import 'package:studiosync/core/data/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';
import 'package:studiosync/modules/trainer/features/profile/domain/repositories/i_trainer_repository.dart';


class FirestoreTrainerRepository implements ITrainerRepository {
  final FirestoreService _firestoreService;
  FirestoreTrainerRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  @override
  Future<TrainerModel?> getTrainerData(String trainerId) async {
    final trainerMap =
        await _firestoreService.getDocument('trainers', trainerId);

    if (trainerMap == null) return null;

    return TrainerModel.fromJson(trainerMap);
  }

  @override
  Future<void> saveTrainer(TrainerModel trainerModel) async {
    await _firestoreService.setDocument(
      'trainers',
      trainerModel.userId,
      trainerModel.toMap(),
    );
  }

  @override
  Future<void> deleteTrainer(TrainerModel trainerModel) {
    // TODO: implement deleteTrainer
    throw UnimplementedError();
  }
}
