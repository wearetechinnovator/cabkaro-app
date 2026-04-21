import 'package:cabkaro/widgets/listing/listing_bottom_dock.dart';
import 'package:cabkaro/widgets/search_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_listing_header.dart';
// import '../../widgets/cabslider/cabslider.dart';
import '../../widgets/cabslider/cabdata.dart';
import 'grayed_cab_card.dart';
import 'package:cabkaro/widgets/cabslider/cabcard.dart';

class BookedCabScreen extends StatefulWidget {
  const BookedCabScreen();

  @override
  State<BookedCabScreen> createState() => _BookedCabScreenState();
}

class _BookedCabScreenState extends State<BookedCabScreen> {
  static const List<CabData> _cabs = [
    CabData(
      driverName: 'Mark',
      carModel: 'Sedan - A1243XG',
      fare: '₹ 800 /-',
      eta: '30 Mins',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    const int isBooked = 1;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              children: [
                UserListingHeader(),
                SizedBox(height: 24),
                Searchcard(onSubmit: () {}),
                SizedBox(height: 14),

                // CabSlider(),
                if (isBooked == 1) ...[
                  Text("Booked Cabs", style: GoogleFonts.oswald(fontSize: 24)),
                  SizedBox(height: 12),

                  // booked cabs — normal colored
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
                  Text(
                    "Available Cabs",
                    style: GoogleFonts.oswald(fontSize: 24),
                  ),
                  SizedBox(height: 12),

                  // available cabs — greyed out
                  ..._cabs.map(
                    (cab) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GreyedCabCard(cab: cab, screenWidth: screenWidth),
                    ),
                  ),
                ],
              ],
            ),
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
