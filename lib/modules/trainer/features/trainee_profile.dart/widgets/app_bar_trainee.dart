import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/shared/widgets/custom_image.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';

class AppBarTraineeWidget extends StatelessWidget {
  final TraineeModel trainee;
  final double rectangleHeight;

  const AppBarTraineeWidget({
    Key? key,
    required this.trainee,
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
                AppStyle.softOrange
                    .withOpacity(0.8), // Lighter shade of softOrange
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
        ),
        // User Image
        Positioned(
          left: (MediaQuery.of(context).size.width - 100) / 2,
          top: rectangleHeight - 60, // מקם את התמונה מחוץ ל-container
          child: CustomImageWidget(
            height: 100,
            width: 100,
            imageUrl: trainee.imgUrl,
            borderColor: trainee.isActive()
                ? Colors.greenAccent.withOpacity(0.5)
                : Colors.redAccent.withOpacity(0.5),
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
            )),
      ],
    );
  }
}
