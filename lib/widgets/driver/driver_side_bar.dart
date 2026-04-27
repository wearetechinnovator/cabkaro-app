import 'package:cabkaro/controllers/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverSidebar extends StatelessWidget {
  const DriverSidebar();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EditProfileController>();
    final userData = controller.userData;
    final String name = userData?['name'] ?? 'User';

    return Drawer(
      backgroundColor: const Color(0xFFE8E8E8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 0),
            decoration: const BoxDecoration(color: Color(0xFFF8C100)),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFF1F1F1F), size: 45),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      color: const Color(0xFF1F1F1F),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/driver-edit-profile'),
                    child: const Text(
                      "Edit Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          _DrawerTile(
            icon: Icons.route_outlined,
            label: "Ongoing Rides",
            onTap: () => Navigator.pushNamed(context, '/ongoing-rides'),
          ),
          _DrawerTile(
            icon: Icons.history_rounded,
            label: "Last Ride",
            onTap: () => Navigator.pushNamed(context, '/driver-ride-history'),
          ),
          _DrawerTile(
            icon: Icons.directions_car_filled_rounded,
            label: "Car Details",
            onTap: () => Navigator.pushNamed(context, '/car-details'),
          ),
          _DrawerTile(
            icon: Icons.badge_outlined,
            label: "Driver Details",
            onTap: () => Navigator.pushNamed(context, '/driver-details-listing'),
          ),

          const Spacer(),
          const Divider(),

          _DrawerTile(
            icon: Icons.logout_rounded,
            label: "Logout",
            textColor: Colors.redAccent,
            iconColor: Colors.redAccent,
            onTap: () => controller.logout(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color textColor;
  final Color iconColor;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.textColor = const Color(0xFF2D2F35),
    this.iconColor = const Color(0xFF2D2F35),
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
    );
  }
}