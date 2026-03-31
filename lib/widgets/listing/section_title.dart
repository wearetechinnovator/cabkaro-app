import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F1F1F),
      ),
    );
  }
}
