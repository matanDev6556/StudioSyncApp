
import 'package:studiosync/core/data/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/domain/repositories/i_trainees_list_repository.dart';

class FirestoreTraineesListRepository implements ITraineesListRepository {
  final FirestoreService _firestoreService;

  FirestoreTraineesListRepository({required FirestoreService firestoreService}): _firestoreService = firestoreService;

  @override
  Future<List<TraineeModel>> getTraineesOfTrainer(String trainerId) async {
    // Fetch all trainees under the trainer's sub-collection "trainees"
    var querySnapshot = await _firestoreService.firestore
        .collection('trainers')
        .doc(trainerId)
        .collection('trainees')
        .get();

    // Map the query results to a list of TraineeModel objects
    List<TraineeModel> traineesList = querySnapshot.docs.map((doc) {
      return TraineeModel.fromJson(doc.data());
    }).toList();

    return traineesList;
  }
}
