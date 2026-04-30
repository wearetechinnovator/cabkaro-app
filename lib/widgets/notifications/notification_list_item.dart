import 'package:flutter/material.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    super.key,
    required this.title,
    required this.routeText,
    this.time,
  });

  final String title;
  final String routeText;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _NotificationAvatar(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF2D2F35),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                routeText,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1F1F1F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (time != null) ...[
                const SizedBox(height: 2),
                Text(
                  time!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5B5B5B),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _NotificationAvatar extends StatelessWidget {
  const _NotificationAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF1EBB63), Color(0xFFF8C100)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF2D2F35), width: 1),
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFCE4A4A),
        ),
        alignment: Alignment.center,
        child: const Text(
          'MK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
