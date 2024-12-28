import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class ExpandableList<T> extends StatelessWidget {
  final String title;
  final List<T> list;
  final Widget Function(T) itemBuilder;
  final VoidCallback onAddItem;
  final Function(T) onRemoveItem;
  final IconData? iconData;

  const ExpandableList({
    Key? key,
    required this.title,
    required this.list,
    required this.itemBuilder,
    required this.onAddItem,
    required this.onRemoveItem,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: iconData != null
              ? Icon(iconData, color: AppStyle.softOrange, size: 24.sp)
              : null,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 17.sp,
              color: AppStyle.deepBlackOrange,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: AppStyle.softOrange,
                  size: 22.sp,
                ),
                onPressed: onAddItem,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppStyle.softOrange,
                size: 24.sp,
              ),
            ],
          ),
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (context, index) => Divider(
                color: AppStyle.backGrey2.withOpacity(0.5),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final item = list[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    title: itemBuilder(item),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline,
                          color: Colors.red, size: 24.sp),
                      onPressed: () => onRemoveItem(item),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
