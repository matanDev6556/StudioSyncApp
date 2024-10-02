import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/shared/models/user_model.dart';
import 'package:studiosync/core/shared/widgets/custom_image.dart';
import 'package:studiosync/core/theme/app_style.dart';

class CustomAppBarTabs extends StatelessWidget implements PreferredSizeWidget {
  final UserModel userModel;
  final VoidCallback onEditPressed;
  final VoidCallback onNotificationPressed;
  final bool thereIsNotifications;
  final bool isLoading;

  const CustomAppBarTabs({
    Key? key,
    this.isLoading = false,
    required this.userModel,
    required this.onEditPressed,
    required this.onNotificationPressed,
    required this.thereIsNotifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      backgroundColor: AppStyle.softOrange,
      automaticallyImplyLeading: false,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: SafeArea(
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Prevent column from taking extra space
            children: [
              Flexible(
                child: SizedBox(
                  width: 100.w,
                  height: 100.h,
                  child: CustomImageWidget(
                    imageUrl: userModel.imgUrl,
                    onEdit: onEditPressed,
                    isLoading: isLoading,
                  ),
                ),
              ),
              Flexible(
                child: TrainerInfo(
                  name: userModel.userFullName,
                  location: userModel.userCity,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: NotificationIcon(
            thereIsNotifications: thereIsNotifications,
            onPressed: onNotificationPressed,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(180.h);
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
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          location,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class UserImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onEditPressed;
  final VoidCallback onImagePressed;

  const UserImage({
    Key? key,
    required this.imageUrl,
    required this.onEditPressed,
    required this.onImagePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: GestureDetector(
              onTap: onImagePressed,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ).animate().fadeIn().scaleY(),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.orange,
                onPressed: onEditPressed,
              ),
            ),
          ),
        ),
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
    return IconButton(
      icon: Icon(
        Icons.notification_important_sharp,
        color: thereIsNotifications ? Colors.redAccent : Colors.white,
        size: 25.w,
      ),
      onPressed: onPressed,
    );
  }
}
