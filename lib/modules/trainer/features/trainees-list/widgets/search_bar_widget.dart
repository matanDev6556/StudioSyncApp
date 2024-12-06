import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/shared/widgets/custom_text_field.dart';
import 'package:studiosync/core/theme/app_style.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onFilterChanged;
  final String dropdownValue;

  const SearchBarWidget({
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.dropdownValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  icon: Icon(
                    Icons.search,
                    color: AppStyle.softOrange,
                    size: 24.w,
                  ),
                  hintText: 'Search by name or city...',
                  hintColor: AppStyle.backGrey3.withOpacity(0.7),
                  fill: true,
                  color: Colors.white,
                  onChanged: onSearchChanged,
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppStyle.deepBlackOrange,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: AppStyle.softOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon:
                        Icon(Icons.arrow_drop_down, color: AppStyle.softOrange),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppStyle.deepBlackOrange,
                    ),
                    dropdownColor: Colors.white,
                    items: ['All', 'Active', 'Inactive']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: onFilterChanged,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
