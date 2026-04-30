import 'package:cabkaro/controllers/user_controller.dart';
import 'package:cabkaro/screens/user/user_ride_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/utils/constants.dart' as constant;

class UserListingHeader extends StatelessWidget {
  const UserListingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _ProfileAvatar(),
        const Spacer(),
        _IconCircle(
          icon: Icons.notifications_none_rounded,
          onTap: () => Navigator.pushNamed(context, '/notifications'),
        ),
        const SizedBox(width: 12),
        _IconCircle(
          icon: Icons.history_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserRideHistoryScreen()),
          ),
        ),
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
    final controller = context.watch<UserController>();
    String name = controller.userName ?? '';
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,

          image: DecorationImage(
            image: NetworkImage(
              '${constant.imgUrl}/${Provider.of<UserController>(context, listen: true).userImg}',
              
            ),
            fit: BoxFit.cover,

          ),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
