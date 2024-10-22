import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class TraineeListService {
  final FirestoreService firestoreService;

  TraineeListService(this.firestoreService);

  Future<List<TraineeModel>> fetchTrainees(String trainerId) async {
    try {
      // Define the filters
      Map<String, dynamic> filters = {
        'trainerID': trainerId,
      };

      // Fetch the trainees
      final traineesDocs =
          await firestoreService.getCollectionWithFilters('users', filters);

      // Return the trainees list
      return traineesDocs.map((doc) => TraineeModel.fromJson(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching trainees: $e');
    }
  }

  Stream<TraineeModel?> getTraineeStream(String userId) {
    return firestoreService.firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return TraineeModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
