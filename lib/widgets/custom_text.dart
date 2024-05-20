import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final List<Shadow> shadows;
  final String text;
  final double fontSize;
  const CustomText(
      {super.key,
      required this.shadows,
      required this.fontSize,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: shadows,
      ),
    );
  }
}
