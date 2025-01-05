import 'package:flutter/material.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';

class CustomDialog extends StatelessWidget {
  final String msg;
  final Function() onConfirm;

  const CustomDialog({
    Key? key,
    required this.msg,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(msg),
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.grey),
          ),
          child: const Text('Cancel'),
          onPressed: () {
            AppRouter.navigateBack();
          },
        ),
        TextButton(
          onPressed: () {
            onConfirm();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
