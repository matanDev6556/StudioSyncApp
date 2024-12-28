import 'package:flutter/material.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class WeekDaysSelector extends StatelessWidget {
  // מקבל את היום הנבחר כפרופרטי מבחוץ
  final int selectedDayIndex;
  final Function(int) onDaySelected;

  // ימים בשבוע
  final List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  WeekDaysSelector({super.key, required this.selectedDayIndex, required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(days.length, (index) {
          bool isSelected = index == selectedDayIndex;
          return GestureDetector(
            onTap: () {
              onDaySelected(index); // שולח את הבחירה למקום שמנהל את הסטייט
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppStyle.softOrange.withOpacity(0.5)
                    : AppStyle.softOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppStyle.deepBlackOrange.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Text(
                days[index].substring(0, 3),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppStyle.softBrown
                      : AppStyle.softBrown.withOpacity(0.4),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}