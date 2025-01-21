class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({required this.startDate, required this.endDate});

  static DateRange getCurrentMonth() {
    final now = DateTime.now();
    return DateRange(
      startDate: DateTime(now.year, now.month, 1),
      endDate: now,
    );
  }

  static DateRange getPreviousMonth() {
    final now = DateTime.now();
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    return DateRange(
      startDate: DateTime(now.year, now.month - 1, 1),
      endDate: firstDayOfCurrentMonth.subtract(const Duration(days: 1)),
    );
  }
}
