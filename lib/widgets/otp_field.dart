import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double screenHeight;
  final Function(String) onChanged;
  final Function() onBackspace;

  const OTPField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.screenHeight,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.35,
      height: 46.74,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0x33FFFFFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFF5E5951),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFFF8C100),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFF5E5951),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.zero, 
            // isDense: true, 
        ),
        style: TextStyle(
          fontSize: screenHeight * 0.03,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D2D2D),
        ),
      ),
    );
    
  }
}
