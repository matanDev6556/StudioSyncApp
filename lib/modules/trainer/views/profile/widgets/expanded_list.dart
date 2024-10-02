import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/theme/app_style.dart';

class ExpandableList<T> extends StatelessWidget {
  final String title;
  final List<T> list;
  final Widget Function(T) itemBuilder;
  final VoidCallback onAddItem;
  final Function(T) onRemoveItem;
  final IconData? iconData; // הוספת שדה לאייקון

  const ExpandableList({
    super.key,
    required this.title,
    required this.list,
    required this.itemBuilder,
    required this.onAddItem,
    required this.onRemoveItem,
    this.iconData, // הוספת השדה לקונסטרוקטור
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 245, 245, 245),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        leading: iconData != null
            ? Icon(iconData, color: AppStyle.darkOrange)
            : null, // הוספת האייקון לצד השמאלי
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppStyle.darkOrange,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: AppStyle.backGrey3,
              ),
              onPressed: onAddItem,
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppStyle.backGrey3,
            ), // אייקון של חץ לפתיחה/סגירה
          ],
        ),
        children: list.map((item) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2), // הצללה
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  itemBuilder(item),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onRemoveItem(item),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
