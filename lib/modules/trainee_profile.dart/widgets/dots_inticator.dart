import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:studiosync/core/theme/app_style.dart';

class DotsIndicatorWidget extends StatelessWidget {
  final int dotsCount;
  final int activePosition;

  const DotsIndicatorWidget(
      {super.key, required this.dotsCount, required this.activePosition});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DotsIndicator(
        dotsCount: dotsCount,
        position: activePosition.toInt(),
        decorator: DotsDecorator(
          activeColor: AppStyle.deepOrange,
          size: const Size.square(7.5),
          activeSize: const Size(25, 5),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
