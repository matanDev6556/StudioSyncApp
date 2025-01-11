import 'package:studiosync/modules/workouts/data/model/workout_model.dart';
import 'package:studiosync/modules/workouts/domain/repository/i_workouts_repository.dart';


class StreamWorkoutChangesUseCase {
  final IWorkoutRepository _iWorkoutRepository;

  StreamWorkoutChangesUseCase({required IWorkoutRepository iWorkoutRepository}) : _iWorkoutRepository = iWorkoutRepository;

  Stream<List<WorkoutModel>> call(String trainerId, String traineeId) {
    return _iWorkoutRepository.streamWorkoutChanges(trainerId, traineeId);
  }
}