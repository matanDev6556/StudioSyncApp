import 'package:uuid/uuid.dart';

class LessonModel {
  final String id;
  final String trainerID;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String day;
  final int limitPeople;
  final String typeLesson;
  final String trainerName;
  final String location;
  final List<String> traineesRegistrations;

  LessonModel({
    String? id,
    required this.startDateTime,
    required this.endDateTime,
    required this.day,
    required this.limitPeople,
    required this.typeLesson,
    required this.trainerName,
    required this.trainerID,
    required this.location,
    this.traineesRegistrations = const <String>[],
  }) : id = id ?? const Uuid().v4();

  bool isLessonFull() {
    return traineesRegistrations.length >= limitPeople;
  }

  // toJson ו-fromJson יצרו ויפענחו את ה- DateTime
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      day: json['day'],
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      limitPeople: json['limitPeople'] as int,
      typeLesson: json['typeLesson'] as String,
      trainerName: json['trainerName'] as String,
      trainerID: json['trainerID'] as String,
      location: json['location'] as String,
      traineesRegistrations: List<String>.from(json['traineesRegistrations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'day': day,
      'limitPeople': limitPeople,
      'typeLesson': typeLesson,
      'trainerName': trainerName,
      'trainerID': trainerID,
      'location': location,
      'traineesRegistrations': traineesRegistrations,
    };
  }

  // Copy with implementation
  LessonModel copyWith({
    String? id,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? day,
    int? limitPeople,
    String? typeLesson,
    String? trainerName,
    String? trainerID,
    String? location,
    List<String>? traineesRegistrations,
  }) {
    return LessonModel(
      id: id ?? this.id,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      day: day ?? this.day,
      limitPeople: limitPeople ?? this.limitPeople,
      typeLesson: typeLesson ?? this.typeLesson,
      trainerName: trainerName ?? this.trainerName,
      trainerID: trainerID ?? this.trainerID,
      location: location ?? this.location,
      traineesRegistrations:
          traineesRegistrations ?? this.traineesRegistrations,
    );
  }

  factory LessonModel.empty() {
    return LessonModel(
      startDateTime: DateTime.now(),
      endDateTime: DateTime.now().add(const Duration(hours: 1)),
      limitPeople: 0,
      typeLesson: '',
      trainerName: '',
      trainerID: '',
      day: '',
      traineesRegistrations: const <String>[],
      location: '',
    );
  }
}
