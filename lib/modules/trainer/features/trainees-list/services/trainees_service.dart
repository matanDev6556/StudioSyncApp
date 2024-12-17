import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class TraineeListService {
  final FirestoreService firestoreService;

  TraineeListService(this.firestoreService);

  Future<List<TraineeModel>> getTraineesForTrainer(String trainerId) async {
    try {
      // Fetch all trainees under the trainer's sub-collection "trainees"
      var querySnapshot = await firestoreService.firestore
          .collection('trainers')
          .doc(trainerId)
          .collection('trainees')
          .get();

      // Map the query results to a list of TraineeModel objects
      List<TraineeModel> traineesList = querySnapshot.docs.map((doc) {
        return TraineeModel.fromJson(doc.data());
      }).toList();

      return traineesList;
    } catch (e) {
      print('Error fetching trainees: $e');
      return [];
    }
  }

  Stream<TraineeModel?> getTraineeStream(String trainerId, String traineeId) {
    return firestoreService.firestore
        .collection('trainers') // מאמנים
        .doc(trainerId) // מזהה המאמן
        .collection('trainees') // אוסף המתאמנים בתוך מסמך המאמן
        .doc(traineeId) // מזהה המתאמן
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return TraineeModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
