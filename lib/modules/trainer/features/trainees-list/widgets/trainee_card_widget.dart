import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/shared/widgets/custom_image.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              CustomImageWidget(
                imageUrl: trainee.imgUrl,
                width: 72.w,
                height: 70.h,
                borderColor: trainee.isActive()
                    ? Colors.greenAccent.withOpacity(0.6)
                    : Colors.redAccent.withOpacity(0.6),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trainee.userFullName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.deepBlackOrange,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      trainee.userCity,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppStyle.backGrey3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        SizedBox(width: 8.w),
                        _buildInfoChip(
                          icon: trainee.subscription != null
                              ? (trainee.subscription!.isActive()
                                  ? Icons.done_rounded
                                  : Icons.close_rounded)
                              : Icons.close_rounded,
                          label: trainee.subscription != null
                              ? (trainee.subscription!.isActive()
                                  ? 'Active'
                                  : 'Inactive')
                              : 'No subscription!',
                        ),
                        if (trainee.startWorOutDate != null)
                          _buildInfoChip(
                            icon: Icons.calendar_today,
                            label: 'Since ${trainee.startWorOutDate!.year}',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppStyle.softOrange,
                size: 24.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppStyle.softOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.w, color: AppStyle.mutedBrown),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppStyle.mutedBrown,
            ),
          ),
        ],
      ),
    );
  }
}
