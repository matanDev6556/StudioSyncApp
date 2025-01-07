import 'package:flutter/material.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class CustomSlider extends StatelessWidget {
  final String sliderName;
  final double initialValue;
  final double minValue;
  final double maxValue;
  final int? divisions;
  final Function(double) onChanged;
  final Color? color;

  const CustomSlider({
    super.key,
    required this.sliderName,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    this.divisions,
    required this.onChanged,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        color: color ?? AppStyle.backGrey2,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(
            '$sliderName ${initialValue.toStringAsFixed(0)}',
            style: TextStyle(
              color: AppStyle.deepBlackOrange,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Slider(
              activeColor: AppStyle.lightOrange,
              inactiveColor: AppStyle.softBrown,
              value: initialValue,
              min: minValue,
              max: maxValue,
              label: initialValue.toStringAsFixed(0),
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
