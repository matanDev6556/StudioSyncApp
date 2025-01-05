// body_parts_summary_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/widgets/custom_container.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/statistics/widgets/body_item.dart';

class BodyPartsSummaryCard extends StatelessWidget {
  final Map<String, double> changes;

  const BodyPartsSummaryCard({
    Key? key,
    required this.changes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (changes.isEmpty) {
      return CustomContainer(
        width: Get.width,
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(16.sp),
        child: Text(
          "Not enough data to show progress.",
          style: AppStyle.bodyTextStyle,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: AppStyle.boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: changes.entries
            .map((entry) => BodyPartChangeItem(
                  bodyPart: entry.key,
                  change: entry.value,
                ))
            .toList(),
      ),
    );
  }
}
