import 'package:flutter/material.dart';
import 'cabdata.dart';
import 'package:google_fonts/google_fonts.dart';
class CabCard extends StatelessWidget {
  

  const CabCard({
    super.key,
    required this.data,
    required this.screenWidth,
    required this.onAccept,
    required this.cardColor,
  });

  final GestureTapCallback onAccept;
  final CabData data;
  final double screenWidth;
  final Color cardColor;
  @override
  Widget build(BuildContext context) {
    return Container(
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
            top: 0, right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: cardColor,
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
                      Text(data.eta, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      Text('From Your Location', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Driver info
          Positioned(
            top: 12, left: 12,
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(data.avatarImage, width: 52, height: 52, fit: BoxFit.cover),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.driverName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(data.carModel, style: TextStyle(fontSize: 13, color: Color(0xFF3E3E3E))),
                  ],
                ),
              ],
            ),
          ),

          // Benefits title
          Positioned(
            top: 65, left: 19,
            child: Text('Benefits', style: GoogleFonts.oswald(fontSize: 16, fontWeight: FontWeight.w700)),
          ),

          // Benefits list
          Positioned(
            bottom: 70, left: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.benefits
                  .map((b) => Text('• $b', style: GoogleFonts.nunitoSans()))
                  .toList(),
            ),
          ),

          // Accept button
          Positioned(
            bottom: 7, left: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF8C100),
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                    onTap: onAccept,
                    child: Center(
                      child: Text(
                        "Accept",
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
            right: 0, top: 60,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF2D2F35),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Text('Fair - ${data.fare}',
                  style: GoogleFonts.oswald(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),

          // Car image
          Positioned(
            bottom: 0, right: 0,
            child: Image.asset(data.carImage, width: 174, fit: BoxFit.contain),
          ),

        ],
      ),
    );
  }
}