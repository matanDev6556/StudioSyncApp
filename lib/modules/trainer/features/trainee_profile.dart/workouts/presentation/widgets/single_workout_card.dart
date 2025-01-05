import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/workouts/data/models/workout_model.dart';
import 'package:studiosync/core/presentation/widgets/custom_container.dart';

class SingleWorkoutWidget extends StatelessWidget {
  final WorkoutModel workout;
  final bool isExpanded;
  final Function(WorkoutModel workout)? onDelete; 
  final Function(WorkoutModel workout)? onEdit; 

  const SingleWorkoutWidget({
    Key? key,
    required this.workout,
    this.isExpanded = false,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, AppStyle.backGrey2.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (onDelete != null)
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => onDelete!(workout),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: AppStyle.backGrey3),
                          onPressed: () => onEdit!(workout),
                        ),
                      ],
                    ),
                  CustomContainer(
                    textColor: AppStyle.softOrange,
                    text: DateFormat('MMM d, y').format(workout.dateScope),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              InfoRowWidget(
                icon: 'assets/icons/weight_icon.png',
                label: 'Weight',
                value: '${workout.weight.toStringAsFixed(1)} kg',
              ),
              Divider(
                thickness: 1,
                color: AppStyle.deepBlackOrange.withOpacity(0.2),
                height: 30.h,
              ),
              isExpanded
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: workout.listScopes.length,
                        itemBuilder: (context, scopeIndex) {
                          final scope = workout.listScopes[scopeIndex];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: InfoRowWidget(
                              icon: 'assets/icons/measure-1-svgrepo-com.png',
                              label: scope.name,
                              value: '${scope.size.toStringAsFixed(1)} cm',
                            ),
                          );
                        },
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: workout.listScopes.length,
                      itemBuilder: (context, scopeIndex) {
                        final scope = workout.listScopes[scopeIndex];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: InfoRowWidget(
                            icon: 'assets/icons/measure-1-svgrepo-com.png',
                            label: scope.name,
                            value: '${scope.size.toStringAsFixed(1)} cm',
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRowWidget extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const InfoRowWidget(
      {Key? key, required this.icon, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppStyle.softOrange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            icon,
            height: 24.h,
            color: AppStyle.softOrange,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: AppStyle.softBrown,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppStyle.backGrey3,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
