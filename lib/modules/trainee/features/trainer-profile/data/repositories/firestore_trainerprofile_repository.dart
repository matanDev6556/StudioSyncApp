import 'package:studiosync/core/data/data_source/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/domain/repositories/i_trainer_profile_repository.dart';
import 'package:studiosync/modules/trainer/features/notifications/data/models/request_model.dart';




class TrainerProfileFirestoreRepository implements ITrainerProfileRepository {
  final FirestoreService firestoreService;

  TrainerProfileFirestoreRepository(this.firestoreService);



  @override
  Future<void> sendRequest(RequestModel request) async {
    await firestoreService.setDocument(
      'trainers/${request.trainerID}/requests',
      request.id,
      request.toMap(),
    );
  }

  @override
  Future<bool> checkIfRequestExists(String traineeID, String trainerID) async {
    final existingRequest = await firestoreService.getCollectionWithFilters(
        'trainers/$trainerID/requests', {'traineeID': traineeID});
    return existingRequest.isNotEmpty;
  }

 
}
