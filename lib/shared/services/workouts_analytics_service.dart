import 'package:studiosync/modules/trainee/models/workout_model.dart';
import 'package:studiosync/shared/models/workout_summary.dart';

class WorkoutAnalytics {
  static int getTotalWorkouts(List<WorkoutModel> workouts) {
    return workouts.length;
  }

  static String getDaysSinceLastWorkout(List<WorkoutModel> workouts) {
    if (workouts.isEmpty) return 'N/A';
    final lastWorkout = workouts.last.dateScope;
    final daysDifference = DateTime.now().difference(lastWorkout).inDays;
    return "$daysDifference days ago";
  }

  static Map<String, dynamic> getBodyPartChanges(List<WorkoutModel> workouts) {
    if (workouts.length < 2) return {};

    Map<String, dynamic> changes = {};
    Map<String, double> firstMeasurements = {};
    Map<String, double> lastMeasurements = {};

    for (var workout in workouts) {
      for (var scope in workout.listScopes) {
        if (!firstMeasurements.containsKey(scope.name)) {
          firstMeasurements[scope.name] = double.parse(scope.size.toString());
        }
        lastMeasurements[scope.name] = double.parse(scope.size.toString());
      }
    }

    for (var bodyPart in lastMeasurements.keys) {
      if (firstMeasurements.containsKey(bodyPart)) {
        double firstMeasurement = firstMeasurements[bodyPart]!;
        double lastMeasurement = lastMeasurements[bodyPart]!;
        if (firstMeasurement != 0) {
          double percentageChange =
              ((lastMeasurement - firstMeasurement) / firstMeasurement) * 100;
          changes[bodyPart] = percentageChange;
        } else {
          changes[bodyPart] = 'N/A';
        }
      }
    }

    return changes;
  }

  static List<double> getWeightData(List<WorkoutModel> workouts) {
    return workouts.map((w) => w.weight).toList();
  }

  static double getMinWeight(List<WorkoutModel> workouts) {
    if (workouts.isEmpty) return 0;
    return workouts.map((w) => w.weight).reduce((a, b) => a < b ? a : b);
  }

  static double getMaxWeight(List<WorkoutModel> workouts) {
    if (workouts.isEmpty) return 0.0;
    return workouts.map((w) => w.weight).reduce((a, b) => a > b ? a : b);
  }

  static double getAvgWeight(List<WorkoutModel> workouts) {
    if (workouts.isEmpty) return 0.0;
    double sum = workouts.map((w) => w.weight).reduce((a, b) => a + b);
    return sum / workouts.length;
  }

  static String getWeightTrendMessage(List<WorkoutModel> workouts) {
    if (workouts.length < 2) {
      return "Not enough data";
    }

    double initialWeight = workouts.first.weight;
    double latestWeight = workouts.last.weight;
    double weightDifference = latestWeight - initialWeight;

    if (latestWeight > initialWeight) {
      return "You've gained ${weightDifference.toStringAsFixed(2)} kg.";
    } else if (latestWeight < initialWeight) {
      return "You've lost ${(-weightDifference).toStringAsFixed(2)} kg.";
    } else {
      return "Your weight remains unchanged.";
    }
  }

  static WorkoutSummary computeWorkoutSummary(List<WorkoutModel> workouts) {
    return WorkoutSummary(
      totalWorkouts: getTotalWorkouts(workouts),
      minWeight: getMinWeight(workouts),
      maxWeight: getMaxWeight(workouts),
      avgWeight: getAvgWeight(workouts),
      daysSinceLastWorkout: getDaysSinceLastWorkout(workouts),
      bodyPartChanges: getBodyPartChanges(workouts),
      weightData: getWeightData(workouts),
      weightTrend: getWeightTrendMessage(workouts),
    );
  }
}
