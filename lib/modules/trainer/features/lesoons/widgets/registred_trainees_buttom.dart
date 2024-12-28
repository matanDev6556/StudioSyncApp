import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/core/presentation/widgets/custom_image.dart';

class RegisteredTrainees extends StatelessWidget {
  const RegisteredTrainees({
    super.key,
    required this.registeredTrainees,
    required this.lessonId,
  });

  final List<TraineeModel> registeredTrainees;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Registered Trainees",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: AppStyle.softBrown,
            ),
          ),
          const SizedBox(height: 16.0),
          registeredTrainees.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: registeredTrainees.length,
                  itemBuilder: (context, index) {
                    final trainee = registeredTrainees[index];

                    return ListTile(
                      leading: CustomImageWidget(
                        imageUrl: trainee.imgUrl,
                        height: 50,
                        width: 50,
                      ),
                      title: Text(trainee.userFullName),
                      subtitle: Text(trainee.userCity),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Get.find<TrainerLessonsController>()
                              .deleteTraineeFromLesson(lessonId, trainee);
                        },
                      ),
                    );
                  },
                )
              : SizedBox(
                  width: Get.width,
                  child: const Text(
                    'No trainees registered yet.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
        ],
      ),
    );
  }
}
