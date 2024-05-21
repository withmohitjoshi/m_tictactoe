import 'package:flutter/material.dart';
import 'package:mp_tictactoe/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const CustomTextField(
      {super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.blue,
          blurRadius: 10,
          spreadRadius: 0,
        )
      ]),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: bgColor,
          filled: true,
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
