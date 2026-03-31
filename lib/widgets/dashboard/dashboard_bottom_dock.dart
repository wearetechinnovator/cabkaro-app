import 'package:flutter/material.dart';

class DashboardBottomDock extends StatelessWidget {
  const DashboardBottomDock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2F35),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DockIcon(
            icon: Icons.home_outlined,
            onTap: () => Navigator.pushReplacementNamed(context, '/listing'),
          ),
          _DockIcon(
            icon: Icons.bar_chart_rounded,
            onTap: () => Navigator.pushReplacementNamed(context, '/listing'),
          ),
          _DockIcon(
            icon: Icons.notifications_none_rounded,
            onTap: () => Navigator.pushReplacementNamed(context, '/notifications'),
          ),
          const _DockIcon(icon: Icons.person_rounded, selected: true),
        ],
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  const _DockIcon({
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(
          icon,
          color: selected ? const Color(0xFFF8C100) : Colors.white,
          size: 27,
        ),
      ),
    );
  }
}
