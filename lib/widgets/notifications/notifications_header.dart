import 'package:flutter/material.dart';

class NotificationsHeader extends StatelessWidget {
  const NotificationsHeader({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onBack,
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFF8C100),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, size: 24),
          ),
        ),
        const Expanded(
          child: Text(
            'Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ),
        const SizedBox(width: 42),
      ],
    );
  }
}
