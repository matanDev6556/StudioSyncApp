import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/widgets/custom_image.dart';
import 'package:studiosync/core/theme/app_style.dart';


class AppBarProfileWidget extends StatelessWidget {
  final String imageUrl;
  final Color borderColor;
  final double rectangleHeight;

  const AppBarProfileWidget({
    Key? key,
    required this.imageUrl,
    required this.borderColor,
    this.rectangleHeight = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Rectangle
        Container(
          width: double.infinity,
          height: rectangleHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppStyle.softOrange.withOpacity(0.8),
                AppStyle.softOrange,
                AppStyle.softOrange.withRed(255),
                AppStyle.softOrange.withRed(255).withBlue(50),
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
        ),
        // User Image
        Positioned(
          left: (MediaQuery.of(context).size.width - 100) / 2,
          top: rectangleHeight - 60,
          child: CustomImageWidget(
            height: 100,
            width: 100,
            imageUrl: imageUrl,
            borderColor: borderColor, // מעביר את הצבע מבחוץ
          ),
        ),
        Positioned(
          left: 15,
          top: 50,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
