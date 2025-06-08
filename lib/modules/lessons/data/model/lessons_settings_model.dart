class LessonsSettingsModel {
  final String message;
  final int? allowedTimeToCancelLesson;
  final int? scheduledDayOfWeek; // 1 = Sunday, 2 = Monday, ...
  final int? scheduledStartHour; // שעה להתחלה (בפורמט 24 שעות)
  final int? scheduledEndHour; // שעה לסיום (בפורמט 24 שעות)
  final bool isFlexibleSchedule;

  LessonsSettingsModel({
    this.message = '',
    this.allowedTimeToCancelLesson,
    this.scheduledDayOfWeek,
    this.scheduledStartHour,
    this.scheduledEndHour,
    this.isFlexibleSchedule = false,
  });

  LessonsSettingsModel copyWith({
    bool? isAllowedToSchedule,
    bool? isAdvancedMode,
    String? message,
    int? allowedTimeToCancelLesson,
    int? scheduledDayOfWeek,
    int? scheduledStartHour,
    int? scheduledEndHour,
    bool? isFlexibleSchedule,
  }) {
    return LessonsSettingsModel(
      message: message ?? this.message,
      allowedTimeToCancelLesson:
          allowedTimeToCancelLesson ?? this.allowedTimeToCancelLesson,
      scheduledDayOfWeek: scheduledDayOfWeek ?? this.scheduledDayOfWeek,
      scheduledStartHour: scheduledStartHour ?? this.scheduledStartHour,
      scheduledEndHour: scheduledEndHour ?? this.scheduledEndHour,
      isFlexibleSchedule: isFlexibleSchedule ?? this.isFlexibleSchedule,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'allowedTimeToCancelLesson': allowedTimeToCancelLesson,
      'scheduledDayOfWeek': scheduledDayOfWeek,
      'scheduledStartHour': scheduledStartHour,
      'scheduledEndHour': scheduledEndHour,
      'isFlexibleSchedule': isFlexibleSchedule,
    };
  }

  factory LessonsSettingsModel.fromMap(Map<String, dynamic> map) {
    return LessonsSettingsModel(
      message: map['message'] ?? '',
      allowedTimeToCancelLesson: map['allowedTimeToCancelLesson'],
      scheduledDayOfWeek: map['scheduledDayOfWeek'],
      scheduledStartHour: map['scheduledStartHour'],
      scheduledEndHour: map['scheduledEndHour'],
      isFlexibleSchedule: map['isFlexibleSchedule'] ?? false,
    );
  }

  bool isAllowedToSchedule() {
    
    if (isFlexibleSchedule) {
      // אם המצב גמיש, אפשר לקבוע בכל זמן
      return true;
    }

    final now = DateTime.now();

    // בדיקה אם היום והשעה הנוכחיים מתאימים לתזמון שנקבע
    if (scheduledDayOfWeek == null || now.weekday != scheduledDayOfWeek) {
      return false;
    }

    if (scheduledStartHour != null && scheduledEndHour != null) {
      final currentHour = now.hour;
      return currentHour >= scheduledStartHour! &&
          currentHour < scheduledEndHour!;
    }

    return false;
  }
}
