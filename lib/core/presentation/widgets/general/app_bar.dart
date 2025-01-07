import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/data/models/user_model.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_image.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class CustomAppBarTabs extends StatelessWidget implements PreferredSizeWidget {
  final UserModel userModel;
  final VoidCallback onEditPressed;
  final VoidCallback? onStatisticPressed;
  final VoidCallback onNotificationPressed;
  final bool thereIsNotifications;
  final bool isLoading;

  const CustomAppBarTabs({
    Key? key,
    this.isLoading = false,
    required this.userModel,
    this.onStatisticPressed,
    required this.onEditPressed,
    required this.onNotificationPressed,
    required this.thereIsNotifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppStyle.softOrange.withOpacity(0.8), // Lighter shade of softOrange
            AppStyle.softOrange, // Original softOrange
            AppStyle.softOrange.withRed(255), // Warmer orange
            AppStyle.softOrange
                .withRed(255)
                .withBlue(50), // Slightly cooler orange
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.h),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NotificationIcon(
                          thereIsNotifications: thereIsNotifications,
                          onPressed: onNotificationPressed,
                        ),
                        onStatisticPressed != null
                            ? IconButton(
                                onPressed: onStatisticPressed,
                                icon: const Icon(
                                  Icons.auto_graph,
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: CustomImageWidget(
                          imageUrl: userModel.imgUrl,
                          onEdit: onEditPressed,
                          isLoading: isLoading,
                        ),
                      ).animate().fadeIn().scale(),
                      SizedBox(height: 12.h),
                      TrainerInfo(
                        name: userModel.userFullName,
                        location: userModel.userCity,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(200.h);
}

class TrainerInfo extends StatelessWidget {
  final String name;
  final String location;

  const TrainerInfo({
    Key? key,
    required this.name,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn().slideY(begin: 0.5, end: 0),
        SizedBox(height: 4.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: Colors.white, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              location,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16.sp,
              ),
            ),
          ],
        ).animate().fadeIn().slideY(begin: 0.5, end: 0),
      ],
    );
  }
}

class NotificationIcon extends StatelessWidget {
  final bool thereIsNotifications;
  final VoidCallback onPressed;

  const NotificationIcon({
    Key? key,
    required this.thereIsNotifications,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
            size: 28.w,
          ),
          onPressed: onPressed,
        ),
        if (thereIsNotifications)
          Positioned(
            right: 8.w,
            top: 0.h,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ).animate().fadeIn().scale();
  }
}
