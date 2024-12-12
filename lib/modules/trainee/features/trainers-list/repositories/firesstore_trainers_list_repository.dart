import 'package:studiosync/core/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/repositories/trainers_list_repositor.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class FirestoreTrainersListRepository implements TrainersListRepository {
  final FirestoreService firestoreService;

  FirestoreTrainersListRepository({required this.firestoreService});

  @override
  Future<List<TrainerModel>> fetchTrainers(String city) async {
    try {
      final trainersMap = await firestoreService.getCollectionWithFilters(
        'trainers',
        city.isNotEmpty ? {'userCity': city} : {},
      );
      return trainersMap.map((e) => TrainerModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching trainers: $e');
    }
  }
}
