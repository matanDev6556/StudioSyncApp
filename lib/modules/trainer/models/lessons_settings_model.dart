class LessonsSettingsModel {
  final String message;
  final int? allowedTimeToCancelLesson;
  final int? scheduledDayOfWeek; // 1 = Sunday, 2 = Monday, ...
  final int? scheduledStartHour; // שעה להתחלה (בפורמט 24 שעות)
  final int? scheduledEndHour; // שעה לסיום (בפורמט 24 שעות)

  LessonsSettingsModel({
    this.message = '',
    this.allowedTimeToCancelLesson,
    this.scheduledDayOfWeek,
    this.scheduledStartHour,
    this.scheduledEndHour,
  });

  LessonsSettingsModel copyWith({
    bool? isAllowedToSchedule,
    bool? isAdvancedMode,
    String? message,
    int? allowedTimeToCancelLesson,
    int? scheduledDayOfWeek,
    int? scheduledStartHour,
    int? scheduledEndHour,
  }) {
    return LessonsSettingsModel(
      message: message ?? this.message,
      allowedTimeToCancelLesson:
          allowedTimeToCancelLesson ?? this.allowedTimeToCancelLesson,
      scheduledDayOfWeek: scheduledDayOfWeek ?? this.scheduledDayOfWeek,
      scheduledStartHour: scheduledStartHour ?? this.scheduledStartHour,
      scheduledEndHour: scheduledEndHour ?? this.scheduledEndHour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'allowedTimeToCancelLesson': allowedTimeToCancelLesson,
      'scheduledDayOfWeek': scheduledDayOfWeek,
      'scheduledStartHour': scheduledStartHour,
      'scheduledEndHour': scheduledEndHour,
    };
  }

  factory LessonsSettingsModel.fromMap(Map<String, dynamic> map) {
    return LessonsSettingsModel(
      message: map['message'] ?? '',
      allowedTimeToCancelLesson: map['allowedTimeToCancelLesson'],
      scheduledDayOfWeek: map['scheduledDayOfWeek'],
      scheduledStartHour: map['scheduledStartHour'],
      scheduledEndHour: map['scheduledEndHour'],
    );
  }

  String getDayAndHoursText() {
    if (scheduledDayOfWeek == null ||
        scheduledStartHour == null ||
        scheduledEndHour == null) {
      return "לא הוגדרו יום ושעות פעילות";
    }

   
    const daysMap = {
      1: "Sunday",
      2: "Monday",
      3: "Tuesday",
      4: "Wednesday",
      5: "Thursday",
      6: "Friday",
      7: "Saturday",
    };

    // המרת השעות לפורמט "HH:MM"
    String formatHour(int hour) => "${hour.toString().padLeft(2, '0')}:00";

    // בניית מחרוזת התוצאה
    final dayText = daysMap[scheduledDayOfWeek] ?? "יום לא ידוע";
    final startHourText = formatHour(scheduledStartHour!);
    final endHourText = formatHour(scheduledEndHour!);

    return "$dayText |  $startHourText - $endHourText";
  }

  bool isAllowedToSchedule() {
    final now = DateTime.now();

    // בדוק אם היום הנוכחי תואם ליום שבחר המאמן
    if (scheduledDayOfWeek == null || now.weekday != scheduledDayOfWeek) {
      return false;
    }

    // בדוק אם הזמן הנוכחי בתוך הטווח שהמאמן קבע
    if (scheduledStartHour != null && scheduledEndHour != null) {
      final currentHour = now.hour;
      return currentHour >= scheduledStartHour! &&
          currentHour < scheduledEndHour!;
    }

    return false;
  }
}
