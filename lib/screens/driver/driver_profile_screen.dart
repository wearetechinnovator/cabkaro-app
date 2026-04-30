
import 'package:cabkaro/controllers/edit_profile_controller.dart';
import 'package:cabkaro/controllers/vendor_controller.dart';
import 'package:cabkaro/screens/driver/driver_listing_header.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cabkaro/widgets/dashboard/dashboard_action_card.dart';
import 'package:cabkaro/widgets/dashboard/dashboard_greeting.dart';
import 'package:cabkaro/widgets/dashboard/dashboard_logout_button.dart';
import 'package:cabkaro/widgets/driver/driver_bottom_dock.dart';



class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<VendorController>(context, listen: false).getVendorDetails(context);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final watchController = Provider.of<VendorController>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      
      
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                const DriverListingHeader(),
                const SizedBox(height: 24),
                DashboardGreeting(name: watchController.vendorName),
                const SizedBox(height: 18),
                DashboardActionCard(
                  userName: watchController.vendorName,
                  phone: watchController.vendorPhone,

                  onEditProfileTap: () {
                    Navigator.pushNamed(context, '/driver-edit-profile');
                  },
                  onLastRideTap: () {
                    Navigator.pushNamed(context, '/driver-ride-history');
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
              child: const DriverBottomDock(),
            ),
          ],
        ),
      ),
    );
  }
}
