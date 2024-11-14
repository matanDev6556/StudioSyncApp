class LessonsSettingsModel {
  final bool isAllowedToSchedule;
  final String message;
  final int? allowedTimeToCancelLesson;

  LessonsSettingsModel({
    this.isAllowedToSchedule = false,
    this.message = '',
    this.allowedTimeToCancelLesson,
  });

  LessonsSettingsModel copyWith({
    bool? isAllowedToSchedule,
    String? message,
    int? allowedTimeToCancelLesson,
  }) {
    return LessonsSettingsModel(
      isAllowedToSchedule: isAllowedToSchedule ?? this.isAllowedToSchedule,
      message: message ?? this.message,
      allowedTimeToCancelLesson: allowedTimeToCancelLesson ?? this.allowedTimeToCancelLesson,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isAllowedToSchedule': isAllowedToSchedule,
      'message': message,
      'allowedTimeToCancelLesson': allowedTimeToCancelLesson,
    };
  }

  factory LessonsSettingsModel.fromMap(Map<String, dynamic> map) {
    return LessonsSettingsModel(
      isAllowedToSchedule: map['isAllowedToSchedule'],
      message: map['message'],
      allowedTimeToCancelLesson: map['allowedTimeToCancelLesson'],
    );
  }
}
