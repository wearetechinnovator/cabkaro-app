import 'package:flutter/material.dart';
import 'package:dashed_border/dashed_border.dart';

class SignupInput extends StatelessWidget {
  const SignupInput({
    super.key,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.controller,
  });

  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenHeight * 0.015;
    final inputHeight = 35.0;
    final iconSize = screenHeight * 0.025;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: DashedBorder(
          color: const Color(0xFF5E5951),
          width: 1.1,
          dashLength: 4.0,
          dashGap: 4.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: SizedBox(
        width: double.infinity,
        height: inputHeight,
        child: TextFormField(
          obscureText: hint.toLowerCase() == "password" ? true : false,
          controller: controller,
          textAlignVertical: TextAlignVertical.center,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: 0,
              height: 0,
            ),
            errorBorder: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              // color: const Color(0xFF3F3A31),
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF4C473F),
              size: iconSize,
            ),
            // filled: true,
            // fillColor: const Color(0x33FFFFFF),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
          ),
          style: TextStyle(
            fontSize: fontSize * 1.1,
            color: const Color(0xFF2D2D2D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
