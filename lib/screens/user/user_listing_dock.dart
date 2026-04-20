import 'package:flutter/material.dart';

class UserListingDock extends StatefulWidget {
  const UserListingDock({super.key});

  @override
  State<UserListingDock> createState() => _UserListingDockState();
}

class _UserListingDockState extends State<UserListingDock> {
  String _currentRoute = '/listing'; // set your default

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute = ModalRoute.of(context)?.settings.name ?? '/listing';
  }

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
            selected: _currentRoute == '/listing',
            onTap: () => Navigator.pushReplacementNamed(context, '/listing'),
          ),
          _DockIcon(
            icon: Icons.bar_chart_rounded,
            selected: _currentRoute == '/booking-details',
            onTap: () => Navigator.pushReplacementNamed(context, '/booking-details'),
          ),
          _DockIcon(
            icon: Icons.notifications_none_rounded,
            selected: _currentRoute == '/notifications',
            onTap: () => Navigator.pushReplacementNamed(context, '/notifications'),
          ),
          _DockIcon(
            icon: Icons.person_rounded,
            selected: _currentRoute == '/dashboard',
            onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
          ),
        ],
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  const _DockIcon({required this.icon, this.selected = false, this.onTap});

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