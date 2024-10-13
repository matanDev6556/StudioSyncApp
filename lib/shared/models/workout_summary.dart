class WorkoutSummary {
  final int totalWorkouts;
  final double minWeight;
  final double maxWeight;
  final double avgWeight;
  final String daysSinceLastWorkout;
  final Map<String, dynamic> bodyPartChanges;
  final List<double> weightData;
  final String weightTrend;

  WorkoutSummary({
    required this.totalWorkouts,
    required this.minWeight,
    required this.maxWeight,
    required this.avgWeight,
    required this.daysSinceLastWorkout,
    required this.bodyPartChanges,
    required this.weightData,
    required this.weightTrend,
  });

  // ... (keep other methods)

  String getFormattedBodyPartChange(String bodyPart) {
    final change = bodyPartChanges[bodyPart];
    if (change == null) return 'N/A';
    if (change is num) {
      final sign = change >= 0 ? '+' : '';
      return '$sign${change.toStringAsFixed(1)}%';
    }
    return 'N/A';
  }
}
