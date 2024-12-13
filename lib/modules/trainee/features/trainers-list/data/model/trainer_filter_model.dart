import 'package:studiosync/modules/trainee/features/trainers-list/presentation/utils/keys_filters_prefrences.dart';

class TrainerFilters {
  bool inMyCity;
  bool markedFilters;
  List<String> lessonsFilter;

  TrainerFilters({
    required this.inMyCity,
    required this.markedFilters,
    required this.lessonsFilter,
  });

  TrainerFilters copyWith({
    bool? inMyCity,
    bool? markedFilters,
    List<String>? lessonsFilter,
  }) {
    return TrainerFilters(
      inMyCity: inMyCity ?? this.inMyCity,
      markedFilters: markedFilters ?? this.markedFilters,
      lessonsFilter: lessonsFilter ?? this.lessonsFilter,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      PreferencesKeys.inMyCity: inMyCity,
      PreferencesKeys.markedFilters: markedFilters,
      PreferencesKeys.lessonFilters: lessonsFilter,
    };
  }

  factory TrainerFilters.fromMap(Map<String, dynamic> map) {
    return TrainerFilters(
      inMyCity: map[PreferencesKeys.inMyCity] ?? false,
      markedFilters: map[PreferencesKeys.markedFilters] ?? false,
      lessonsFilter: List<String>.from(map[PreferencesKeys.lessonFilters] ?? []),
    );
  }
}