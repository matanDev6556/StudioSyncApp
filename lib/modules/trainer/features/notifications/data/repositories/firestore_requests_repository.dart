import 'package:studiosync/core/data/data_source/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/notifications/data/models/request_model.dart';
import 'package:studiosync/modules/trainer/features/notifications/domain/repositories/i_requests_repository.dart';

class FirestoreRequestsRepository implements IRequestsRepository {
  final FirestoreService _firestoreService;
  FirestoreRequestsRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  @override
  Future<void> approveTraineeRequest(
      TraineeModel trainee, String trainerId) async {
    // add trainee to trainer collection
    await _firestoreService.setDocument(
      'trainers/$trainerId/trainees',
      trainee.userId,
      trainee.toMap(),
    );

    // remove trainee from general collection
    await _firestoreService.deleteDocument('trainees', trainee.userId);

    // update that this trainee has trainer and set the trainer id
    await _firestoreService.setDocument(
      'AllTrainees',
      trainee.userId,
      {'id': trainee.userId, 'trainerID': trainerId},
    );

    // remove req from db
    await _firestoreService.deleteDocumentsWithFilters(
      'trainers/$trainerId/requests',
      {'traineeID': trainee.userId},
    );
  }

  @override
  Stream<List<TraineeModel>> listenToTrainerRequests(String trainerId) {
    return _firestoreService
        .streamCollection('trainers/$trainerId/requests')
        .asyncMap((snapshot) async {
      final List<TraineeModel> trainees = [];
      for (var doc in snapshot.docs) {
        final requestData = doc.data();
        final request = RequestModel.fromMap(requestData);

        final traineeData =
            await _firestoreService.getDocument('trainees', request.traineeID);

        if (traineeData != null) {
          trainees.add(TraineeModel.fromJson(traineeData));
        }
      }
      return trainees;
    });
  }

  @override
  Future<void> rejectTraineeRequest(
      TraineeModel trainee, String trainerId) async {
    await _firestoreService.deleteDocumentsWithFilters(
      'trainers/$trainerId/requests',
      {'traineeID': trainee.userId},
    );
  }
}
