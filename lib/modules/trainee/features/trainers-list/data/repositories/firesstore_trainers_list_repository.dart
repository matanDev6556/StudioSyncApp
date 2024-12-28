import 'package:studiosync/core/data/services/firebase/firestore_service.dart';
import 'package:studiosync/modules/trainee/features/trainers-list/domain/repositories/i_trainers_list_repository.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';


class FirestoreTrainersListRepository implements ITrainersListRepository {
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
