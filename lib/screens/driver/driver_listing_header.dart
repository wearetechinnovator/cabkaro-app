import 'package:cabkaro/controllers/edit_profile_controller.dart';
import 'package:cabkaro/screens/driver/driver_profile_screen.dart';
import 'package:cabkaro/screens/driver/driver_ride_history_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DriverListingHeader extends StatelessWidget {
<<<<<<< HEAD
  const DriverListingHeader({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;
=======
  const DriverListingHeader({super.key});
>>>>>>> a64f8e0 (Edit vendor and user profile)

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Menu button to reliably open the Scaffold drawer when tapped.
        InkWell(
          borderRadius: BorderRadius.circular(20),
<<<<<<< HEAD
          onTap: () {
            print('scaffoldKey state: ${scaffoldKey.currentState}');
            scaffoldKey.currentState?.openDrawer();
          },
=======
          onTap: () => Scaffold.of(context).openDrawer(),
>>>>>>> a64f8e0 (Edit vendor and user profile)
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2D2F35), width: 1.2),
            ),
            child: const Icon(Icons.menu, size: 20, color: Color(0xFF2D2F35)),
          ),
        ),
        const SizedBox(width: 12),
        // const _ProfileAvatar(),
        const Spacer(),
        _IconCircle(
          icon: Icons.notifications_none_rounded,
          onTap: () => Navigator.pushNamed(context, '/driver-notification'),
        ),
        const SizedBox(width: 12),
        _IconCircle(
          icon: Icons.history_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RideHistoryScreen()),
          ),
        ),
        // const SizedBox(width: 12),
        // _IconCircle(
        //   // driver-only, e.g. earnings
        //   icon: Icons.account_balance_wallet_outlined,
        //   onTap: () => Navigator.pushNamed(context, '/earnings'),
        // ),
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

<<<<<<< HEAD
=======

>>>>>>> a64f8e0 (Edit vendor and user profile)
// ignore: unused_element
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DriverProfileScreen()),
      ),
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
