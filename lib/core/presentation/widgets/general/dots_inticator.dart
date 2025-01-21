import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class DotsIndicatorWidget extends StatelessWidget {
  final int dotsCount;
  final int activePosition;

  const DotsIndicatorWidget({
    super.key,
    required this.dotsCount,
    required this.activePosition,
  }) : assert(dotsCount > 0, 'dotsCount must be greater than zero');

  @override
  Widget build(BuildContext context) {
    final safeActivePosition = activePosition.clamp(0, dotsCount - 1);
    return Center(
      child: DotsIndicator(
        dotsCount: dotsCount,
        position: safeActivePosition,
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
