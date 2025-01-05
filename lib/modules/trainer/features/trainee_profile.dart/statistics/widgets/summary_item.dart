// summary_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const SummaryItem({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppStyle.softOrange, size: 24.sp),
        SizedBox(height: 8.h),
        Text(label, style: AppStyle.summaryLabelStyle),
        SizedBox(height: 4.h),
        Text(value, style: AppStyle.softValueStyle),
      ],
    );
  }
}
