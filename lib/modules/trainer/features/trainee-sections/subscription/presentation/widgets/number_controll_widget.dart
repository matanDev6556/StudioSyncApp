
import 'package:flutter/material.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class WorkoutNumberControlRow extends StatelessWidget {
  final int value;
  final Function onRemoveTap;
  final Function onAddTap;
  final Color? backColor;
  final Color? txtColor;

  const WorkoutNumberControlRow({
    Key? key,
    required this.value,
    required this.onRemoveTap,
    required this.onAddTap,
    this.backColor,
    this.txtColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: backColor ?? AppStyle.softOrange,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: 18,
                color: txtColor ?? AppStyle.backGrey3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Spacer(),
        CircleAvatar(
          backgroundColor: AppStyle.backGrey2,
          child: IconButton(
            onPressed: () => onRemoveTap(),
            icon: const Icon(Icons.remove),
          ),
        ),
        AppStyle.w(5),
        CircleAvatar(
          backgroundColor: AppStyle.softOrange.withOpacity(0.5),
          child: IconButton(
            onPressed: () => onAddTap(),
            icon: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
