import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/widgets/trainee_card_widget.dart';

class TraineesListWidget extends StatelessWidget {
  final List<TraineeModel> traineesList;
  // final int? workoutsLength;
  final bool isLoading;

  const TraineesListWidget({
    required this.traineesList,
    required this.isLoading,
    //required this.workoutsLength,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (traineesList.isEmpty) {
      return const Center(
        child: Text(
          'No Trainers yet!',
          style: TextStyle(fontSize: 18, color: Color(0xffB77F00)),
        ),
      );
    }

    return ListView.builder(
      itemCount: traineesList.length,
      itemBuilder: (context, index) {
        final trainee = traineesList[index];
        
        return TraineeCardWidget(
          //workoutsLength: workoutsLength,
          trainee: trainee,
          onTap: () => Get.toNamed(Routes.profileTrainee, arguments: trainee),
        );
      },
    );
  }
}
