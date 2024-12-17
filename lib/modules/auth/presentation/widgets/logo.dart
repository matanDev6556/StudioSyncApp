import 'package:flutter/widgets.dart';

class Logo extends StatelessWidget {
  final double widht;
  const Logo({super.key, required this.widht});

  @override
  Widget build(BuildContext context) {
    {
      return SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Image.asset(
                'assets/icons/logo.png',
                width: widht,
              ),
            ],
          ),
        ),
      );
    }
  }
}
