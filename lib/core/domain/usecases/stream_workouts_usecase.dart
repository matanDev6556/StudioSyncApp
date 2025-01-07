import 'package:studiosync/core/data/models/workout_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/domain/repositories/i_workouts_repository.dart';


class StreamWorkoutChangesUseCase {
  final IWorkoutRepository _iWorkoutRepository;

  StreamWorkoutChangesUseCase({required IWorkoutRepository iWorkoutRepository}) : _iWorkoutRepository = iWorkoutRepository;

  Stream<List<WorkoutModel>> call(String trainerId, String traineeId) {
    return _iWorkoutRepository.streamWorkoutChanges(trainerId, traineeId);
  }
}