import 'package:cabkaro/screens/user/booked_cab_screen.dart';
import 'package:cabkaro/widgets/cabslider/cabcard.dart';
import 'package:cabkaro/widgets/listing/listing_header.dart';
import 'package:cabkaro/widgets/search_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/cabslider/cabdata.dart';
import '../../widgets/listing/listing_bottom_dock.dart';

class AvailableCabsScreen extends StatefulWidget {
  const AvailableCabsScreen({super.key});

  @override
  State<AvailableCabsScreen> createState() => _AvailableCabsScreenState();
}

class _AvailableCabsScreenState extends State<AvailableCabsScreen> {
  static const List<CabData> _cabs = [
    CabData(
      driverName: 'Mark',
      carModel: 'Sedan - A1243XG',
      fare: '₹ 800 /-',
      eta: '30 Mins',
    ),
    CabData(
      driverName: 'Harry',
      carModel: 'Sedan - B7732AR',
      fare: '₹ 840 /-',
      eta: '25 Mins',
    ),
    CabData(
      driverName: 'Samar',
      carModel: 'Sedan - D3345TR',
      fare: '₹ 760 /-',
      eta: '34 Mins',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const int acceptedCab = 1;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // sticky header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListingHeader(),
                      SizedBox(height: 12),
                      SizedBox(
                        width: screenWidth - 32,
                        child: Searchcard(onSubmit: () {}),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),

                // scrollable list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    children: [
                      // newly cabs section — only if accepted
                      if (acceptedCab == 0) ...[
                        Text(
                          "Accepted Cabs",
                          style: GoogleFonts.oswald(fontSize: 24),
                        ),
                        SizedBox(height: 12),
                        ..._cabs.map(
                          (cab) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CabCard(
                              cardColor: Color(0xFFF8C100),
                              data: cab,
                              // screenWidth: screenWidth,
                              onAccept: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookedCabScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                      ],

                      // available cabs section
                      Text(
                        "Available Cabs",
                        style: GoogleFonts.oswald(fontSize: 24),
                      ),
                      SizedBox(height: 12),
                      ..._cabs.map(
                        (cab) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CabCard(
                            cardColor: Color(0xFFF8C100),
                            data: cab,
                            // screenWidth: screenWidth,
                            onAccept: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookedCabScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // bottom dock
            Positioned(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              bottom: 16,
              child: const ListingBottomDock(),
            ),
          ],
        ),
      ),
    );
  }
}
