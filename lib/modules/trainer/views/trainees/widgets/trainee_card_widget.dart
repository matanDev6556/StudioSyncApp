import 'package:flutter/material.dart';
import 'package:studiosync/core/shared/widgets/custom_image.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class TraineeCardWidget extends StatelessWidget {
  final TraineeModel trainee;
  final VoidCallback onTap;

  const TraineeCardWidget({
    required this.trainee,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: CustomImageWidget(
          imageUrl: trainee.imgUrl,
          width: 70,
          borderColor: trainee.isActive()
              ? Colors.greenAccent.withOpacity(0.8)
              : Colors.redAccent.withOpacity(0.8),
        ),
        title: Text(
          trainee.userFullName,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xffC77C00)),
        ),
        subtitle: Text(
          trainee.userCity,
          style: const TextStyle(color: Color(0xffB77F00)),
        ),
        trailing:  Icon(Icons.arrow_forward_ios, color: AppStyle.softOrange),
        onTap: onTap,
      ),
    );
  }
}