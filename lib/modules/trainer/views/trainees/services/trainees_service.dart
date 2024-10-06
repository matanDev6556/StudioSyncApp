import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class TraineeService {
  final FirestoreService firestoreService;

  TraineeService(this.firestoreService);

  Future<List<TraineeModel>> fetchTrainees(String trainerId) async {
    try {
      // Define the filters
      Map<String, dynamic> filters = {
        'trainerID': trainerId,
      };

      // Fetch the trainees
      final traineesDocs =
          await firestoreService.getCollectionWithFilters('trainees', filters);

      // Return the trainees list
      return traineesDocs.map((doc) => TraineeModel.fromJson(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching trainees: $e');
    }
  }
}