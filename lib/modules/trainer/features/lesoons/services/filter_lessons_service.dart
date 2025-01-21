import 'package:studiosync/modules/lessons/data/model/lesson_model.dart';

class LessonTrainerFilterService {
  List<LessonModel> filterLessons(
    List<LessonModel> lessons,
    int selectedDayIndex,
    String statusFilter,
    String trainerFilter,
    String typeFilter,
    String locationFilter,
  ) {
    List<LessonModel> filtered = filterByDay(lessons, selectedDayIndex);
    filtered = _filterByStatus(filtered, statusFilter);
    filtered = filterByTrainer(filtered, trainerFilter);
    filtered = filterByType(filtered, typeFilter);
    filtered = filterByLocation(filtered, locationFilter);

    filtered.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
    return filtered;
  }

  List<LessonModel> filterByDay(List<LessonModel> lessons, int dayIndex) {
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

  List<LessonModel> filterByTrainer(List<LessonModel> lessons, String trainer) {
    if (trainer == 'All') return lessons;
    return lessons.where((lesson) => lesson.trainerName == trainer).toList();
  }

  List<LessonModel> filterByType(List<LessonModel> lessons, String type) {
    if (type == 'All') return lessons;
    return lessons.where((lesson) => lesson.typeLesson == type).toList();
  }

  List<LessonModel> filterByLocation(List<LessonModel> lessons, String location) {
    if (location == 'All') return lessons;
    return lessons.where((lesson) => lesson.location == location).toList();
  }
}