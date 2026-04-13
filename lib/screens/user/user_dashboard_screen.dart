import '../common/booking_details_screen.dart';
import 'package:flutter/material.dart';
import '../../widgets/dashboard/dashboard_action_card.dart';
import '../../widgets/dashboard/dashboard_bottom_dock.dart';
import '../../widgets/dashboard/dashboard_greeting.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_logout_button.dart';
// import 'EditProfileScreen.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                const DashboardGreeting(name: 'User1257'),
                const SizedBox(height: 18),
                DashboardActionCard(
                  userName: 'User1257',
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
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                ),
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
