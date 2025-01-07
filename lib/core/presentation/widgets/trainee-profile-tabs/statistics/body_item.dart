// body_part_change_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class BodyPartChangeItem extends StatelessWidget {
  final String bodyPart;
  final double change;

  const BodyPartChangeItem({
    Key? key,
    required this.bodyPart,
    required this.change,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color changeColor = change > 0
        ? Colors.green
        : (change < 0 ? Colors.red : AppStyle.backGrey3);
    String changeText = change == 0
        ? 'No change'
        : '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(bodyPart, style: AppStyle.bodyTextStyle),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: changeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(changeText, style: TextStyle(color: changeColor)),
          ),
        ],
      ),
    );
  }
}