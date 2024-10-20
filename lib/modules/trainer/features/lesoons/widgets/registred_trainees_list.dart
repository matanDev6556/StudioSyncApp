
import 'package:flutter/material.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:studiosync/shared/widgets/custom_image.dart';

class RegistredTrainees extends StatelessWidget {
  const RegistredTrainees({
    super.key,
    required this.registeredTrainees,
  });

  final List<TraineeModel> registeredTrainees;

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
          ListView.builder(
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
                    // פונקציה להסרת המתאמן מהרשימה
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
