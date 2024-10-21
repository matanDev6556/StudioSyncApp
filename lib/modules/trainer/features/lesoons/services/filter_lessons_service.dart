import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';

class LessonFilterService {
  List<LessonModel> filterLessons(
    List<LessonModel> lessons,
    int selectedDayIndex,
    String statusFilter,
    String trainerFilter,
    String typeFilter,
    String locationFilter,
  ) {
    List<LessonModel> filtered = _filterByDay(lessons, selectedDayIndex);
    filtered = _filterByStatus(filtered, statusFilter);
    filtered = _filterByTrainer(filtered, trainerFilter);
    filtered = _filterByType(filtered, typeFilter);
    filtered = _filterByLocation(filtered, locationFilter);

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

  List<LessonModel> _filterByStatus(List<LessonModel> lessons, String option) {
    final now = DateTime.now();
    switch (option) {
      case 'Active':
        final todayStart = DateTime(now.year, now.month, now.day);
        final todayEnd = todayStart.add(const Duration(days: 1));

        return lessons.where((lesson) {
          return lesson.startDateTime.isAfter(todayStart) &&
              lesson.startDateTime.isBefore(todayEnd) &&
              lesson.endDateTime.isAfter(now);
        }).toList();
      case 'Past':
        return lessons.where((lesson) => lesson.endDateTime.isBefore(now)).toList();
      case 'Upcoming':
        return lessons.where((lesson) => lesson.startDateTime.isAfter(now)).toList();
      case 'All':
        return lessons;
      default:
        return lessons;
    }
  }

  List<LessonModel> _filterByTrainer(List<LessonModel> lessons, String trainer) {
    if (trainer == 'All') return lessons;
    return lessons.where((lesson) => lesson.trainerName == trainer).toList();
  }

  List<LessonModel> _filterByType(List<LessonModel> lessons, String type) {
    if (type == 'All') return lessons;
    return lessons.where((lesson) => lesson.typeLesson == type).toList();
  }

  List<LessonModel> _filterByLocation(List<LessonModel> lessons, String location) {
    if (location == 'All') return lessons;
    return lessons.where((lesson) => lesson.location == location).toList();
  }
}