// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cabkaro/controllers/car_details_controller.dart';
import 'package:cabkaro/controllers/driver/driver_ride_controller.dart';
import 'package:cabkaro/controllers/vendor_controller.dart';
import 'package:cabkaro/screens/driver/driver_listing_header.dart';
import 'package:cabkaro/screens/user/ride_details_screen.dart';
import 'package:cabkaro/widgets/Request_card.dart';
import 'package:cabkaro/widgets/driver/driver_side_bar.dart';
import 'package:cabkaro/widgets/shimmer/driver_rides_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabkaro/widgets/driver/driver_bottom_dock.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverRideController>().getRide(context);
      context.read<VendorController>().getVendorDetails(context);
      context.read<CarDetailsController>().getVendorVehicles(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final driverRideController = context.watch<DriverRideController>();
    List<dynamic> availableRides = driverRideController.availableRides;
    bool isLoading = driverRideController.isLoading;

    return Scaffold(
      drawer: const DriverSidebar(),
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () =>
                  context.read<DriverRideController>().refreshRides(context),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                children: [
                  DriverListingHeader(),
                  SizedBox(height: 24),
                  // Text(
                  //   'Dashboard',
                  //   style: TextStyle(
                  //     fontSize: 28,
                  //     fontWeight: FontWeight.w600,
                  //     color: Color(0xFF1F1F1F),
                  //     height: 1,
                  //   ),
                  // ),
                  SizedBox(height: 16),
                  if (isLoading)
                    DriverRidesShimmer()
                  else if (availableRides.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No available rides',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(
                      availableRides.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RideDetailsScreen(
                                  rideData: availableRides[index],
                                ),
                              ),
                            );
                          },
                          child: RequestCard(rideData: availableRides[index]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              bottom: 16,
              child: const DriverBottomDock(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Dot
// ─────────────────────────────────────────────

class _Dot extends StatefulWidget {
  const _Dot();

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11,
      height: 11,
      decoration: const BoxDecoration(
        color: Color(0xFFF8C100),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Color(0xFF2D2F35),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
