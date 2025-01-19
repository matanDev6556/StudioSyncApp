import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DatesUtils {
  // function for when user pick dateTime i check that the date he choose is in the samee day he choosed
  static String getDayFromIndex(int index) {
    switch (index) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '';
    }
  }

  // this function return how mutch the trainee with date subscription has days left
  static String daysLeft(DateTime startDate, DateTime endDate) {
    DateTime currentDate = DateTime.now();
    int totalDays = endDate.difference(startDate).inDays;
    int daysLeft = currentDate.difference(startDate).inDays;

    return '$daysLeft / $totalDays days';
  }

  static String getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    if (month >= 1 && month <= 12) {
      return monthNames[month - 1];
    } else {
      return 'Invalid Month';
    }
  }

  // schedule_utils.dart

  static String getDayAndHoursText({
    int? dayOfWeek,
    int? startHour,
    int? endHour,
  }) {
    if (dayOfWeek == null ||
        startHour == null ||
        endHour == null) {
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
    final dayText = daysMap[dayOfWeek] ?? "יום לא ידוע";
    final startHourText = formatHour(startHour);
    final endHourText = formatHour(endHour);

    return "$dayText |  $startHourText - $endHourText";
  }

  static String getHourFormat(TimeOfDay startTime, TimeOfDay endTime) {
    return '${startTime.hour.toString().padLeft(2, "0")}:${startTime.minute.toString().padLeft(2, "0")} - ${endTime.hour.toString().padLeft(2, "0")}:${endTime.minute.toString().padLeft(2, "0")}';
  }

  static String getFormattedStartDate(DateTime? date) {
    return date != null ? DateFormat('yMMMMd').format(date) : 'Not start yet';
  }

  static Future<DateTime?> selectDateTime(DateTime initialDate) async {
    // pick date
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // pick time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        // full DateTime
        return DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
    return null; // החזר null אם הבחירה בוטלה
  }
}
