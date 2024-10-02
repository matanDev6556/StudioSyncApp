import 'package:flutter/material.dart';
import 'package:studiosync/core/theme/app_style.dart';

class TitleWithAddBttn extends StatelessWidget {
  const TitleWithAddBttn({
    super.key,
    required this.title,
    required this.addBttn,
  });

  final String title;
  final Function addBttn;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: AppStyle.deepBlackOrange,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: AppStyle.deepOrange,
              size: 35,
            ),
            onPressed: () => addBttn(),
          ),
        ],
      ),
    );
  }
}
