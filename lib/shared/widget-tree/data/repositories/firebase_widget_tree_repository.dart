import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_auth_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import 'package:studiosync/shared/widget-tree/domain/repositories/i_widget_tree_repository.dart';

class WidgetTreeFirebaseRepository implements IWidgetTreeRepository {
  final FirestoreService _firestoreService;

  WidgetTreeFirebaseRepository({
    required FirestoreService firestoreService,
    required IAuthRepository iAuthRepository,
  }) : _firestoreService = firestoreService;

  @override
  Future<String?> checkUserRole(String uid) async {
    final trainerData = await _firestoreService.getDocument('trainers', uid);
    if (trainerData != null) return 'trainer';

    final traineeData = await _firestoreService.getDocument('AllTrainees', uid);
    if (traineeData != null) return 'trainee';

    return null;
  }

  @override
  Future<TraineeModel?> getTraineeData(String uid) async {
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

  @override
  Future<TrainerModel?> getTrainerData(String uid) async {
    final trainerMap = await _firestoreService.getDocument('trainers', uid);

    if (trainerMap == null) return null;

    return TrainerModel.fromJson(trainerMap);
  }
}
