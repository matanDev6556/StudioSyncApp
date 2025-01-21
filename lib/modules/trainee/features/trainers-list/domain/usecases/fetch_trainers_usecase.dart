import 'package:studiosync/modules/trainee/features/trainers-list/domain/repositories/i_trainers_list_repository.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';


class FetchTrainersUseCase {
  final ITrainersListRepository _trainersListRepository;

  FetchTrainersUseCase({required ITrainersListRepository trainersListRepository}) : _trainersListRepository = trainersListRepository;

  Future<List<TrainerModel>> execute(String userCity ) async {
    final trainersList = await _trainersListRepository.fetchTrainers(userCity);
    return trainersList;
  }

  
}
