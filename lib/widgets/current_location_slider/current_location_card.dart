import 'package:flutter/material.dart';
import 'current_location_data.dart';
import 'package:google_fonts/google_fonts.dart';

class CabCard extends StatelessWidget {
  const CabCard({
    super.key,
    required this.data,
    // required this.screenWidth,
    required this.onAccept,
    required this.cardColor,
  });

  final GestureTapCallback onAccept;
  final CabData data;
  // final double screenWidth;
  final Color cardColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
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
          // Driver info
          Positioned(
            top: 12,
            left: 12,
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    data.avatarImage,
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
                      data.driverName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      data.carModel,
                      style: TextStyle(fontSize: 13, color: Color(0xFF3E3E3E)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Positioned(
          //   bottom: 15,
          //   left: 19,
          //   child: Text(
          //     'Contai,WestBengal,\nPurba Medinipur,721450',
          //     style: GoogleFonts.oswald(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),

          // View card
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF8C100),
                borderRadius: BorderRadius.circular(15),
              ),
              child: GestureDetector(
                onTap: onAccept,
                child: Center(
                  child: Text(
                    "View",
                    style: GoogleFonts.oswald(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Benifits
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF2D2F35),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: data.benefits
                    .map(
                      (b) => Text(
                        '• $b',
                        style: GoogleFonts.nunitoSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
