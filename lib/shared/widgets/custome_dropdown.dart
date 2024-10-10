import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/theme/app_style.dart';

class CustomDropDown<T> extends StatelessWidget {
  final String? hintText;
  final T? initialValue;
  final Function(T?) onChanged;
  final List<T> items;
  final String Function(T)
      itemLabelBuilder; // פונקציה לבניית התווית עבור כל פריט
  final Color? color;
  final Color? textColor; // צבע הטקסט
  final Icon? icon;

  const CustomDropDown({
    super.key,
    required this.onChanged,
    required this.items,
    required this.itemLabelBuilder,
    this.initialValue,
    this.hintText,
    this.color,
    this.textColor, // צבע הטקסט
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppStyle.backGrey2,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height * 0.06,
      width: MediaQuery.of(context).size.width * 0.85,
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: icon,
          hintText: hintText ?? 'Select an option',
          hintStyle: TextStyle(
            color: textColor ?? AppStyle.backGrey3, // צבע הטקסט
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        value: initialValue,
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemLabelBuilder(item),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor ?? AppStyle.backGrey3, // צבע הטקסט
              ),
            ),
          );
        }).toList(),
        isExpanded: true, // כדי שה-dropdown יהיה ברוחב מלא
        alignment: Alignment.centerRight, // מיקום הטקסט המרכזי
      ),
    );
  }
}
