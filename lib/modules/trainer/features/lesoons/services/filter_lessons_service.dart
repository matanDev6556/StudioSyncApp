import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

class LessonFilterService {
  List<LessonModel> filterLessons(
    List<LessonModel> lessons,
    int selectedDayIndex,
    String filterOption,
  ) {
    List<LessonModel> filtered = _filterByDay(lessons, selectedDayIndex);
    filtered = _filterByOption(filtered, filterOption);
    filtered.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
    return filtered;
  }

  List<LessonModel> _filterByDay(List<LessonModel> lessons, int dayIndex) {
    if (dayIndex == -1) return lessons;
    return lessons.where((lesson) {
      if (dayIndex == 0) return lesson.startDateTime.weekday == 7;
      return lesson.startDateTime.weekday == dayIndex;
    }).toList();
  }

  List<LessonModel> _filterByOption(List<LessonModel> lessons, String option) {
    final now = DateTime.now();
    switch (option) {
      case 'Active':
        final todayStart =
            DateTime(now.year, now.month, now.day); // Start of today
        final todayEnd = todayStart.add(const Duration(days: 1)); // Start of tomorrow

        return lessons.where((lesson) {
          return lesson.startDateTime.isAfter(todayStart) &&
              lesson.startDateTime.isBefore(todayEnd) &&
              lesson.endDateTime.isAfter(now);
        }).toList();
      case 'Past':
        return lessons
            .where((lesson) => lesson.endDateTime.isBefore(now))
            .toList();
      case 'Upcoming':
        return lessons
            .where((lesson) => lesson.startDateTime.isAfter(now))
            .toList();
      case 'All':
        return lessons;
      default:
        return lessons;
    }
  }
}
