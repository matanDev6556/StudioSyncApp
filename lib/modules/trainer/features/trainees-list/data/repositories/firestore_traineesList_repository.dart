import 'package:studiosync/core/data/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/domain/repositories/i_trainees_list_repository.dart';

class FirestoreTraineesListRepository implements ITraineesListRepository {
  final FirestoreService _firestoreService;

  FirestoreTraineesListRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  @override
  Stream<List<TraineeModel>> streamTraineesOfTrainer(String trainerId) {
    // Fetch all trainees under the trainer's sub-collection "trainees"
    return _firestoreService
        .streamCollection('trainers/$trainerId/trainees')
        .map((snapshot) =>
            snapshot.docs.map((doc) => TraineeModel.fromJson(doc.data())).toList());
  }
}
