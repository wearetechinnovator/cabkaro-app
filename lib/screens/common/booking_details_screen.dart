import 'package:cabkaro/widgets/listing/listing_bottom_dock.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/listing/section_title.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),

              children: [
                SectionTitle(title: 'Booking Details'),
                SizedBox(height: 14),
                Container(
                  width: screenWidth - 30,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Color(0xFFF4E5B0),
                    borderRadius: BorderRadius.circular(25),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFF4D4D4D), width: 4),
                      right: BorderSide(color: Color(0xFF4D4D4D), width: 4),
                      top: BorderSide(color: Color(0xFF4D4D4D), width: 2),
                      left: BorderSide(color: Color(0xFF4D4D4D), width: 2),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ETA badge
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8C100),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(22),
                              bottomLeft: Radius.circular(18),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 18),
                              SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "30 Dec", 
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '9:30 A:M',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Driver info
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                "assets/images/avatar.png",
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jeena",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Sedan - A12345XG",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF3E3E3E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Accept button
                      Positioned(
                        bottom: 7,
                        left: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8C100),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GestureDetector(
                            child: Center(
                              child: Text(
                                "Call : 890 000 0000",
                                style: GoogleFonts.oswald(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Fare badge
                      Positioned(
                        right: 0,
                        top: 50,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF2D2F35),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Fair - ₹800 /-',
                            style: GoogleFonts.oswald(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      // Car image
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image.asset(
                          "assets/images/carimg.png",
                          width: 174,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 77,
                        left: 49,
                        child: Text(
                          "Contai",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Positioned(
                        top: 137,
                        left: 49,
                        child: Text(
                          "Digha",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 130,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1DA20B),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Transform.rotate(
                              angle: -0.35,
                              child: Text(
                                "Ride\nBooked",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oswald(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 30,
                        child: Image.asset(
                          "assets/icons/Ellipse.png",
                          width: 14,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 92,
                        left: 30,
                        child: Image.asset(
                          "assets/icons/Line.png",
                          width: 14,
                          height: 49,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 140,
                        left: 30,
                        child: Image.asset(
                          "assets/icons/Ellipse.png",
                          width: 14,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
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
