import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Icon? icon;
  final String hintText;
  final Color hintColor;
  final bool fill;
  final Color color;
  final double? width;
  final int? maxLines;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final double? height;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool isHinttextCenter;
  final TextStyle? textStyle;

  const CustomTextField({
    super.key,
    this.icon,
    required this.hintText,
    required this.hintColor,
    required this.fill,
    required this.color,
    this.maxLines = 1,
    required this.onChanged,
    this.validator,
    this.height,
    this.width,
    this.initialValue,
    this.textStyle,
    this.isHinttextCenter = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    //final containerHeight = height ?? MediaQuery.of(context).size.height * 0.06;
    final initialString = initialValue ?? '';
    //final containerWidth = width ?? MediaQuery.of(context).size.width * 0.85;

    return TextFormField(
      textAlign: isHinttextCenter ? TextAlign.center : TextAlign.start,
      initialValue: initialString,
      style: textStyle,
      validator: (val) {
        if (validator != null) {
          return validator!(val); // Only call the validator if it's not null
        }
        return null; // Return null if there's no validator
      },
      onChanged: (val) {
        onChanged(val);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: fill,
        fillColor: color,
        hintText: hintText,
        hintStyle: TextStyle(
          color: fill ? hintColor : color,
        ),
        prefixIcon: icon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: color,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: color, // Change the color as needed
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: color,
          ),
        ),
      ),
    );
  }
}
