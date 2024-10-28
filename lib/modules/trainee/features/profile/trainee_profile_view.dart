import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/controllers/trainee_controller.dart';

class TraineeProfileTab extends StatelessWidget {
  final TraineeController traineeController = Get.find();
  TraineeProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        IconButton(
          onPressed: () => traineeController.logout(),
          icon: Icon(Icons.logout),
        ),
      ],
    ));
  }
}
