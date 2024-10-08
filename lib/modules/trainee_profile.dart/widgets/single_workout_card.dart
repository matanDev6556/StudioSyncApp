import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainee/models/workout.dart';

class SingleWorkoutWidget extends StatelessWidget {
  final WorkoutModel workout;
  final bool isExpanded;

  const SingleWorkoutWidget(
      {Key? key, required this.workout, this.isExpanded = false})
      : super(key: key);

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
            colors: [AppStyle.backGrey2, AppStyle.backGrey2.withOpacity(0.8)],
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
                  Text(
                    'Date',
                    style: TextStyle(
                      color: AppStyle.softBrown,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppStyle.softOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      DateFormat('MMM d, y')
                          .format(workout.dateScope ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppStyle.softOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              _buildInfoRow(
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
                            child: _buildInfoRow(
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
                          child: _buildInfoRow(
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

  Widget _buildInfoRow(
      {required String icon, required String label, required String value}) {
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
