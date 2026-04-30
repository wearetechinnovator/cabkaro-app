<<<<<<< HEAD
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
=======
import 'package:cabkaro/controllers/vendor_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cabkaro/utils/constants.dart' as constant;

class DriverSidebar extends StatelessWidget {
  const DriverSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VendorController>();
>>>>>>> a64f8e0 (Edit vendor and user profile)

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
<<<<<<< HEAD
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFF1F1F1F), size: 45),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
=======
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      "${constant.imgUrl}/${controller.vendorImg}",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.vendorName,
>>>>>>> a64f8e0 (Edit vendor and user profile)
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oswald(
                      color: const Color(0xFF1F1F1F),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
<<<<<<< HEAD
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
=======
>>>>>>> a64f8e0 (Edit vendor and user profile)
                ],
              ),
            ),
          ),

          _DrawerTile(
            icon: Icons.route_outlined,
            label: "Ongoing Rides",
<<<<<<< HEAD
            onTap: () => Navigator.pushNamed(context, '/ongoing-rides'),
=======
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ongoing-rides');
            },
>>>>>>> a64f8e0 (Edit vendor and user profile)
          ),
          _DrawerTile(
            icon: Icons.history_rounded,
            label: "Last Ride",
<<<<<<< HEAD
            onTap: () => Navigator.pushNamed(context, '/driver-ride-history'),
=======
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/driver-ride-history');
            },
>>>>>>> a64f8e0 (Edit vendor and user profile)
          ),
          _DrawerTile(
            icon: Icons.directions_car_filled_rounded,
            label: "Car Details",
<<<<<<< HEAD
            onTap: () => Navigator.pushNamed(context, '/car-details'),
=======
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/car-details');
            },
>>>>>>> a64f8e0 (Edit vendor and user profile)
          ),
          _DrawerTile(
            icon: Icons.badge_outlined,
            label: "Driver Details",
<<<<<<< HEAD
            onTap: () => Navigator.pushNamed(context, '/driver-details-listing'),
=======
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/driver-details-listing');
            },
>>>>>>> a64f8e0 (Edit vendor and user profile)
          ),

          const Spacer(),
          const Divider(),

          _DrawerTile(
            icon: Icons.logout_rounded,
            label: "Logout",
            textColor: Colors.redAccent,
            iconColor: Colors.redAccent,
<<<<<<< HEAD
            onTap: () => controller.logout(context),
          ),
          const SizedBox(height: 20),
=======
            onTap: () => Provider.of<VendorController>(
              context,
              listen: false,
            ).logout(context),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
<<<<<<< HEAD
}
=======
}
>>>>>>> a64f8e0 (Edit vendor and user profile)
