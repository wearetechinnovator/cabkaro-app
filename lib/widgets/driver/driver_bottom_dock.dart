import 'package:flutter/material.dart';

class DriverBottomDock extends StatefulWidget {
  const DriverBottomDock({super.key});

  @override
  State<DriverBottomDock> createState() => _DriverBottomDockState();
}

class _DriverBottomDockState extends State<DriverBottomDock> {
  String _currentRoute = '/driver-home';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute = ModalRoute.of(context)?.settings.name ?? '/driver-home';
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
          // Home → driver home (available rides / no-rides)
          _DockIcon(
            icon: Icons.home_outlined,
            selected: _currentRoute == '/driver-home',
            onTap: () =>
                Navigator.pushNamed(context, '/driver-home'),
          ),
          // Chart → driver ride history
          _DockIcon(
            icon: Icons.bar_chart_rounded,
            selected: _currentRoute == '/driver-ride-history',
            onTap: () =>
                Navigator.pushNamed(context, '/driver-ride-history'),
          ),
          // Notifications → driver notifications
          _DockIcon(
            icon: Icons.notifications_none_rounded,
            selected: _currentRoute == '/driver-notifications',
            onTap: () => Navigator.pushNamed(
              context,
              '/driver-notifications',
            ),
          ),
          // Profile → driver profile
          _DockIcon(
            icon: Icons.person_rounded,
            selected: _currentRoute == '/driver-profile',
            onTap: () =>
                Navigator.pushNamed(context, '/driver-profile'),
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
