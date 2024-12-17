import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';


enum FilterType { trainer, lesson, location }

class LessonsTraineeFilterService {
  final RxList<String> _trainersFilter = <String>[].obs;
  final RxList<String> _lessonsFilter = <String>[].obs;
  final RxList<String> _locationFilter = <String>[].obs;

  List<String> get trainersFilter => _trainersFilter;
  List<String> get lessonsFilter => _lessonsFilter;
  List<String> get locationFilter => _locationFilter;

  

  void toggleFilter(FilterType type, String value, {bool add = true}) {
    final filter = _getFilterByType(type);

    if (add) {
      filter.add(value);
    } else {
      filter.remove(value);
    }
  }

  RxList<String> _getFilterByType(FilterType type) {
    switch (type) {
      case FilterType.trainer:
        return _trainersFilter;
      case FilterType.lesson:
        return _lessonsFilter;
      case FilterType.location:
        return _locationFilter;
    }
  }

  bool filterUpcomingLessons(LessonModel lesson) {
    final now = DateTime.now();
    return lesson.startDateTime.isAfter(now) ||
        lesson.startDateTime.isAtSameMomentAs(now);
  }

  bool filterByTrainers(LessonModel lesson) =>
      trainersFilter.isEmpty || trainersFilter.contains(lesson.trainerName);

  bool filterByLessons(LessonModel lesson) =>
      lessonsFilter.isEmpty || lessonsFilter.contains(lesson.typeLesson);

  bool filterByLocation(LessonModel lesson) =>
      locationFilter.isEmpty || locationFilter.contains(lesson.location);

  bool filterByDay(LessonModel lesson, int dayIndex) {
    if (dayIndex == 0 && lesson.startDateTime.weekday == 7) {
      return true;
    }
    return lesson.startDateTime.weekday == dayIndex;
  }

  List<LessonModel> applyFilters(List<LessonModel> lessons, int dayIndex) {
    return lessons.where((lesson) {
      final isUpcoming = filterUpcomingLessons(lesson);
      final matchesTrainer = filterByTrainers(lesson);
      final matchesLessonType = filterByLessons(lesson);
      final matchesLocation = filterByLocation(lesson);
      final matchDay = filterByDay(lesson, dayIndex);

      return isUpcoming &&
          matchDay &&
          matchesTrainer &&
          matchesLessonType &&
          matchesLocation;
    }).toList();
  }
}
