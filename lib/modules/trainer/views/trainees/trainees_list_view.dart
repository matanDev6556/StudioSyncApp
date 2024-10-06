import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/shared/widgets/custom_image.dart';
import 'package:studiosync/core/shared/widgets/custom_text_field.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/contollers/trainees_controller.dart';

class TraineesListView extends GetView<TraineesController> {
  const TraineesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          icon: Icon(
                            Icons.search,
                            color: AppStyle.backGrey3,
                          ),
                          hintText: 'Search..',
                          hintColor: AppStyle.backGrey3,
                          fill: true,
                          color: AppStyle.backGrey,
                          onChanged: (val) {},
                        ),
                      ),
                      AppStyle.w(20.w),
                      DropdownButton<String>(
                        value: 'All',
                        items: <String>['All', 'Active', 'Inactive']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {},
                      ),
                    ],
                  ),
                  AppStyle.h(15.h),
                  Text(
                    'Trainees : ${controller.traineesList.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.deepBlackOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (controller.traineesList.isEmpty) {
              return const Center(
                child: Text(
                  'No Trainers yet!',
                  style: TextStyle(fontSize: 18, color: Color(0xffB77F00)),
                ),
              );
            }
            return ListView.builder(
              itemCount: controller.traineesList.length,
              itemBuilder: (context, index) {
                final trainee = controller.traineesList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 2,
                  child: ListTile(
                    leading: Stack(
                      alignment: Alignment.center,
                      children: [
                        // התמונה של המתאמן
                        CustomImageWidget(
                          imageUrl: trainee.imgUrl,
                          width: 70,
                          borderColor: trainee.isActive()
                              ? Colors.greenAccent.withOpacity(0.8)
                              : Colors.redAccent.withOpacity(0.8),
                        ),
                      ],
                    ),
                    title: Text(
                      trainee.userFullName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffC77C00)),
                    ),
                    subtitle: Text(
                      trainee.userCity,
                      style: const TextStyle(color: Color(0xffB77F00)),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppStyle.softOrange,
                    ),
                    onTap: () {
                      // כאן תוכל להוסיף פעולה בעת לחיצה על מתאמן
                    },
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'סינון מתאמנים:',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xffB77F00)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _filterChip('גיל', onSelected: (selected) {
                // Implement age filter logic
              }),
              _filterChip('עיר', onSelected: (selected) {
                // Implement city filter logic
              }),
              _filterChip('תאריך התחלה', onSelected: (selected) {
                // Implement start date filter logic
              }),
              _filterChip('מנוי פעיל', onSelected: (selected) {
                // Implement active subscription filter logic
              }),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'חיפוש מתאמנים...',
              prefixIcon: const Icon(Icons.search, color: Color(0xffEDA400)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xffEDA400)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    const BorderSide(color: Color(0xffEDA400), width: 2),
              ),
            ),
            onChanged: (value) {
              // Implement search logic
            },
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {required Function(bool) onSelected}) {
    return FilterChip(
      label: Text(label),
      onSelected: onSelected,
      selectedColor: const Color(0xffEDA400),
      checkmarkColor: Colors.white,
      backgroundColor: const Color(0xffEDEDED),
      labelStyle: const TextStyle(color: Color(0xffB77F00)),
    );
  }
}
