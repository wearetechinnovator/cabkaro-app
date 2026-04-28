import 'package:cabkaro/controllers/edit_profile_controller.dart';
import 'package:cabkaro/controllers/vendor_controller.dart';
import 'package:provider/provider.dart';
import '../common/booking_details_screen.dart';
import 'package:flutter/material.dart';
import '../../widgets/dashboard/dashboard_action_card.dart';
import '../../widgets/dashboard/dashboard_bottom_dock.dart';
import '../../widgets/dashboard/dashboard_greeting.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_logout_button.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<EditProfileController>(context, listen: false).getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final Map<String, dynamic> userData =
        Provider.of<EditProfileController>(context, listen: true).userData ??
        {"name": "Loading...", "phone": "Loading..."};

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                DashboardHeader(onBack: () => Navigator.pop(context)),
                const SizedBox(height: 24),
                DashboardGreeting(name: userData['name']),
                const SizedBox(height: 18),
                DashboardActionCard(
                  userName: userData['name'],
                  onEditProfileTap: () {
                    Navigator.pushNamed(context, '/edit-profile');
                  },
                  onLastRideTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingDetailsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              left: 18,
              bottom: 130,
              child: DashboardLogoutButton(
                onTap: () => Provider.of<VendorController>(
                  context,
                  listen: false,
                ).logout(context),
              ),
            ),
            Positioned(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              bottom: 14,
              child: const DashboardBottomDock(),
            ),
          ],
        ),
      ),
    );
  }
}
