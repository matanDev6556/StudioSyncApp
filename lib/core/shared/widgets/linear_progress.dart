import 'package:flutter/material.dart';
import 'package:studiosync/core/theme/app_style.dart';

class LinearProgressWorkOuts extends StatelessWidget {
  const LinearProgressWorkOuts({
    super.key,
    required this.totalWorkouts,
    required this.howWorkOutsDid,
    required this.isTrainer,
    required this.isActive,
    this.editButton,
  });

  final int? totalWorkouts;
  final int? howWorkOutsDid;
  final bool isTrainer;
  final bool isActive;
  final Function? editButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          //  visibile the edit button only for trainer
          visible: isTrainer,
          child: IconButton(
            onPressed: () {
              editButton!();
            },
            icon: Icon(
              Icons.edit,
              color: AppStyle.backGrey3,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: LinearProgressIndicator(
              minHeight: 20,
              value:
                  (totalWorkouts! > 0) ? howWorkOutsDid! / totalWorkouts! : 0.0,
              backgroundColor: AppStyle.backGrey2,
              valueColor: AlwaysStoppedAnimation<Color>(AppStyle.softOrange),
            ),
          ),
        ),
        AppStyle.w(15),
        CircleAvatar(
          radius: 7,
          backgroundColor: isActive ? Colors.greenAccent : Colors.redAccent,
        ),
      ],
    );
  }
}
