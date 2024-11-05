import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/requests_controller.dart';
import 'package:studiosync/shared/widgets/custom_container.dart';
import 'package:studiosync/shared/widgets/custom_image.dart';

class RequestsTab extends GetView<RequestsController> {
  const RequestsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.traineesRequests.isEmpty) {
        return Center(
          child: Text(
            'No requests yet',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppStyle.softBrown,
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.traineesRequests.length,
        itemBuilder: (context, index) {
          final trainee = controller.traineesRequests[index];
          return _buildRequestItem(trainee);
        },
      );
    });
  }

  Widget _buildRequestItem(TraineeModel trainee) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppStyle.softOrange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CustomImageWidget(
          imageUrl: trainee.imgUrl,
          height: 60.h,
          width: 60.w,
        ),
        title: Text(
          trainee.userFullName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppStyle.softBrown,
          ),
        ),
        subtitle: Text(
          trainee.userCity,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppStyle.softBrown.withOpacity(0.7),
          ),
        ),
        trailing: CustomContainer(
          child: IconButton(
            icon: Icon(Icons.phone, color: AppStyle.softBrown),
            onPressed: () {
              // TODO: Implement call functionality
              // You can use url_launcher package to make a phone call
              // launch("tel:${trainee.phoneNumber}");
            },
          ),
        ),
        onTap: () {
          // TODO: Implement action when tapping on a request
          // For example, show more details or navigate to a detailed view
        },
      ),
    );
  }
}
