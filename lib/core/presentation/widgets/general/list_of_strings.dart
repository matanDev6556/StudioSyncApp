import 'package:flutter/material.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class ListOfStrings extends StatelessWidget {
  const ListOfStrings({
    super.key,
    required this.onTapDelete,
    required this.list,
    this.color = Colors.white,
  });

  final List<String> list;
  final Color color;
  final Function(int index) onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) => AppStyle.w(15),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return Container(
            width: (MediaQuery.of(context).size.width * .66),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 5,
                  backgroundColor: AppStyle.backGrey3,
                ),

                // Use Flexible to make the Text widget take available space
                Flexible(
                  child: Tooltip(
                    message: item, // Show full text as tooltip
                    child: Text(
                      item,
                      overflow: TextOverflow.clip, // Ellipsis for overflow
                      style: TextStyle(
                        color: AppStyle.backGrey3,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                // BTN DELETE LOCATION
                IconButton(
                  onPressed: () => onTapDelete(index),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
