import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/notifications/presentation/requests_controller.dart';
import 'package:studiosync/core/presentation/widgets/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/custom_image.dart';

class RequestsTabView extends GetView<RequestsController> {
 
  const RequestsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppStyle.softOrange),
          ),
        );
      }

      if (controller.traineesRequests.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 60.sp, color: AppStyle.softOrange),
              SizedBox(height: 16.h),
              Text(
                'No requests yet',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppStyle.softBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppStyle.softOrange.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(16.w),
            leading: Hero(
              tag: 'trainee_${trainee.userId}',
              child: CircleAvatar(
                radius: 30.r,
                backgroundColor: AppStyle.softOrange.withOpacity(0.2),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: trainee.imgUrl,
                    height: 60.h,
                    width: 60.w,
                  ),
                ),
              ),
            ),
            title: Text(
              trainee.userFullName,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppStyle.softBrown,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 16.sp, color: AppStyle.softOrange),
                    SizedBox(width: 4.w),
                    Text(
                      trainee.userCity,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppStyle.softBrown.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: CustomContainer(
              child: IconButton(
                icon: Icon(Icons.phone, color: AppStyle.softOrange),
                onPressed: () {
                  // TODO: Implement call functionality
                },
              ),
            ),
          ),
          Divider(color: AppStyle.softOrange.withOpacity(0.2)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      
                          await controller.approveTraineeRequest(trainee);
                      
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppStyle.softOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text(
                      'Approve',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller.rejectTraineeRequest(trainee),
                    style: OutlinedButton.styleFrom(
                      primary: AppStyle.softBrown,
                      side: BorderSide(color: AppStyle.softBrown),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
