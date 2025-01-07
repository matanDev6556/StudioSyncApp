import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class SubscriptionTabWidget extends StatelessWidget {
  final TraineeModel trainee;
  final Widget? actions;

  const SubscriptionTabWidget({
    Key? key,
    required this.trainee,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          trainee.subscription!.getSubscriptionContainer(),
          if (actions != null) ...[
            SizedBox(height: 20.h),
            actions!,
          ],
        ],
      ),
    );
  }
}
