import 'package:studiosync/modules/trainee/features/trainers-list/repositories/trainers_list_repositor.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class FetchTrainersUseCase {
  final TrainersListRepository _trainersListRepository;

  FetchTrainersUseCase({required TrainersListRepository trainersListRepository}) : _trainersListRepository = trainersListRepository;

  Future<List<TrainerModel>> execute(String userCity ) async {
    final trainersList = await _trainersListRepository.fetchTrainers(userCity);
    return trainersList;
  }

  
}
