import 'package:studiosync/modules/trainee/features/workouts/domain/repositories/i_workouts_trainee_repository.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/data/models/workout_model.dart';


class ListenWorkoutChangesUseCase {
  final IWorkoutsRepository _repository;

  ListenWorkoutChangesUseCase({required IWorkoutsRepository repository}) : _repository = repository;

  Stream<List<WorkoutModel>> execute(String trainerId, String traineeId) {
    return _repository.getWorkoutChanges(trainerId, traineeId);
  }
}