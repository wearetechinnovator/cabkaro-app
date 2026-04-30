import 'package:cabkaro/screens/user/available_cabs_screen.dart';
import 'package:cabkaro/screens/user/user_ongoing_rides_screen.dart';
import 'package:flutter/material.dart';

class UserListingDock extends StatefulWidget {
  const UserListingDock({super.key});

  @override
  State<UserListingDock> createState() => _UserListingDockState();
}

class _UserListingDockState extends State<UserListingDock> {
  String _currentRoute = '/listing';

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
            onTap: () => Navigator.pushNamed(context, '/listing'),
          ),
          _DockIcon(
            icon: Icons.bar_chart_rounded,
            selected: _currentRoute == '/booking-details',
            onTap: () => Navigator.pushNamed(context, '/booking-details'),
          ),
          _DockIcon(
            icon: Icons.car_repair,
            selected: _currentRoute == '/booking-details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AvailableCabsScreen(rideId: "1"),
                ),
              );
            },
          ),

          // // ── Ride / Driver Search shortcut ─────────────────────────────
          // _RideSearchDockButton(
          //   selected: _currentRoute == '/driver-searching',
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => const DriverSearchingScreen(),
          //         settings: const RouteSettings(name: '/driver-searching'),
          //       ),
          //     );
          //   },
          // ),
          // // ─────────────────────────────────────────────────────────────
          _DockIcon(
            icon: Icons.watch_later_outlined,
            selected: _currentRoute == '/notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserOngoingRidesScreen(),
                ),
              );
            },
          ),
          _DockIcon(
            icon: Icons.person_rounded,
            selected: _currentRoute == '/dashboard',
            onTap: () => Navigator.pushNamed(context, '/dashboard'),
          ),
        ],
      ),
    );
  }
}

/// Highlighted "create ride → search screen" button in the dock.
class _RideSearchDockButton extends StatelessWidget {
  const _RideSearchDockButton({required this.onTap, this.selected = false});

  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 38,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF8C100)
              : const Color(0xFFF8C100).withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF8C100), width: 1.5),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFF8C100).withOpacity(0.35),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Icon(
          Icons.local_taxi_rounded,
          color: selected ? const Color(0xFF1A1C21) : const Color(0xFFF8C100),
          size: 22,
        ),
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
