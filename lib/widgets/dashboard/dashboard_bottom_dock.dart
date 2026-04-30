import 'package:flutter/material.dart';

/// Bottom navigation dock for User's dashboard/profile screens.
/// Routes: Home → /listing, Bookings → /booking-details,
///         Notifications → /notifications, Profile → /dashboard
class DashboardBottomDock extends StatefulWidget {
  const DashboardBottomDock({super.key});

  @override
  State<DashboardBottomDock> createState() => _DashboardBottomDockState();
}

class _DashboardBottomDockState extends State<DashboardBottomDock> {
  String _currentRoute = '/dashboard';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute =
        ModalRoute.of(context)?.settings.name ?? '/dashboard';
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
          // Home → user car listing (user's main/home screen)
          _DockIcon(
            icon: Icons.home_outlined,
            selected: _currentRoute == '/listing',
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/listing'),
          ),
          // Bookings → user booking details
          _DockIcon(
            icon: Icons.bar_chart_rounded,
            selected: _currentRoute == '/booking-details',
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/booking-details'),
          ),
          // Notifications
          _DockIcon(
            icon: Icons.notifications_none_rounded,
            selected: _currentRoute == '/notifications',
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/notifications'),
          ),
          // Profile (current screen)
          _DockIcon(
            icon: Icons.person_rounded,
            selected: _currentRoute == '/dashboard' ||
                _currentRoute == '/edit-profile',
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/dashboard'),
          ),
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
