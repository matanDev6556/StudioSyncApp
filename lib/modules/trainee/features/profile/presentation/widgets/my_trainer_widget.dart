import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_image.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';

class MyTrainerWidget extends StatelessWidget {
  final TrainerModel? trainerModel;
  final VoidCallback onClick; 
  const MyTrainerWidget({Key? key, this.trainerModel, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppStyle.softOrange.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: AppStyle.softOrange.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTrainerImage(),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrainerName(),
                SizedBox(height: 4.h),
                _buildTrainerLocation(),
              ],
            ),
          ),
          _buildContactButton(onClick: onClick), // הוספת הפונקציה לקליק לתוך החץ
        ],
      ),
    );
  }

  Widget _buildTrainerImage() {
    return CustomImageWidget(
      imageUrl: trainerModel?.imgUrl,
      height: 80.h,
      width: 80.w,
    );
  }

  Widget _buildTrainerName() {
    return Text(
      trainerModel?.userFullName ?? 'Trainer Name',
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppStyle.deepBlackOrange,
      ),
    );
  }

  Widget _buildTrainerLocation() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16.sp,
          color: AppStyle.softOrange,
        ),
        SizedBox(width: 4.w),
        Text(
          trainerModel?.userCity ?? 'City',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppStyle.softBrown,
          ),
        ),
      ],
    );
  }

  Widget _buildContactButton({required VoidCallback onClick}) {
    return CustomContainer(
      child: IconButton(
        icon: Icon(
          Icons.arrow_forward_ios,
          color: AppStyle.softOrange,
          size: 22.sp,
        ),
        onPressed: onClick, // הוספת הפונקציה לקליק
      ),
    );
  }
}
