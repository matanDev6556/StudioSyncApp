import 'package:studiosync/modules/trainee/features/workouts/domain/repositories/i_workouts_trainee_repository.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';


class FetchWorkoutsUseCase {
  final IWorkoutsRepository _repository;

  FetchWorkoutsUseCase({required IWorkoutsRepository repository }) : _repository = repository;

  Future<List<WorkoutModel>> execute(String trainerId, String traineeId) async {
    return await _repository.fetchWorkouts(trainerId, traineeId);
  }
}