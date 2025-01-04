class MonthlyStats {
  final int sessionsCount;
  final int traineesCount;
  final int newTraineesCount;
  final Set<String> uniqueTrainees;

  MonthlyStats({
    required this.sessionsCount,
    required this.traineesCount,
    required this.newTraineesCount,
    required this.uniqueTrainees,
  });
}