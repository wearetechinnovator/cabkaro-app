import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onBack,
        child: Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFF8C100),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, size: 24, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}
