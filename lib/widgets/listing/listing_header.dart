import 'package:cabkaro/controllers/user/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListingHeader extends StatelessWidget {
  const ListingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _IconCircle(icon: Icons.grid_view_rounded),
        const Spacer(),
        _IconCircle(
          icon: Icons.notifications_none_rounded,
          onTap: () => Navigator.pushNamed(context, '/notifications'),
        ),
        const SizedBox(width: 12),
        const _ProfileAvatar(),
      ],
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF2D2F35), width: 1.2),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF2D2F35)),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EditProfileController>();
    String name = controller.userData?['name'] ?? '';
    final parts = name.trim().split(" ").where((e) => e.isNotEmpty).toList();

    final initials = parts.isEmpty
        ? '?'
        : parts.length == 1
        ? parts[0][0]
        : parts[0][0] + parts[1][0];

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.pushNamed(context, '/dashboard'),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFFF8C100), Color(0xFFDDA200)],
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: TextStyle(
            color: Color(0xFF1F1F1F),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
