import 'package:studiosync/modules/trainee/models/workout_model.dart';

class SortWorkoutsUseCase {
  List<WorkoutModel> call(List<WorkoutModel> workoutsList) {
    return workoutsList
      ..sort((a, b) {
        DateTime dateA = DateTime.parse(a.dateScope.toString());
        DateTime dateB = DateTime.parse(b.dateScope.toString());
        return dateB.compareTo(dateA);
      });
  }
}