import 'package:flutter/material.dart';

class DashboardLogoutButton extends StatelessWidget {
  const DashboardLogoutButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF8C100),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Log Out',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF1F1F1F),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
