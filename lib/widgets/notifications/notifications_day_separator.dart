import 'package:flutter/material.dart';

class NotificationsDaySeparator extends StatelessWidget {
  const NotificationsDaySeparator({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Color(0xFFD0D0D0), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D2F35),
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: Color(0xFFD0D0D0), thickness: 1),
        ),
      ],
    );
  }
}
