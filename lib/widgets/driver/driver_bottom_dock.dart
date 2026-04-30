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
<<<<<<< HEAD
                Navigator.pushReplacementNamed(context, '/driver-home'),
=======
                Navigator.pushNamed(context, '/driver-home'),
>>>>>>> a64f8e0 (Edit vendor and user profile)
          ),
          // Chart → driver ride history
          _DockIcon(
            icon: Icons.bar_chart_rounded,
            selected: _currentRoute == '/driver-ride-history',
            onTap: () =>
<<<<<<< HEAD
                Navigator.pushReplacementNamed(context, '/driver-ride-history'),
=======
                Navigator.pushNamed(context, '/driver-ride-history'),
>>>>>>> a64f8e0 (Edit vendor and user profile)
          ),
          // Notifications → driver notifications
          _DockIcon(
            icon: Icons.notifications_none_rounded,
            selected: _currentRoute == '/driver-notifications',
<<<<<<< HEAD
            onTap: () => Navigator.pushReplacementNamed(
=======
            onTap: () => Navigator.pushNamed(
>>>>>>> a64f8e0 (Edit vendor and user profile)
              context,
              '/driver-notifications',
            ),
          ),
          // Profile → driver profile
          _DockIcon(
            icon: Icons.person_rounded,
            selected: _currentRoute == '/driver-profile',
            onTap: () =>
<<<<<<< HEAD
                Navigator.pushReplacementNamed(context, '/driver-profile'),
=======
                Navigator.pushNamed(context, '/driver-profile'),
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
