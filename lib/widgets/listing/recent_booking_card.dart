import 'package:cabkaro/widgets/modals/review_rating_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentBookingCard extends StatefulWidget {
  const RecentBookingCard({
    super.key,
    required this.customer,
    required this.pickup,
    required this.drop,
    required this.fare,
    this.driverId = '',
    this.rideId = '',
    this.onReviewSubmit,
  });

  final String customer;
  final String pickup;
  final String drop;
  final String fare;
  final String driverId;
  final String rideId;
  final Function(int rating, String review)? onReviewSubmit;

  @override
  State<RecentBookingCard> createState() => _RecentBookingCardState();
}

class _RecentBookingCardState extends State<RecentBookingCard> {
  void _showReviewModal() {
    showDialog(
      context: context,
      builder: (context) => ReviewRatingModal(
        driverName: widget.customer,
        driverId: widget.driverId,
        onSubmit: (rating, review) async {
          if (widget.onReviewSubmit != null) {
            widget.onReviewSubmit!(rating, review);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
          Positioned(
            top: 0, right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                      Text("30 Mins", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 12, left: 12,
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset("assets/images/avatarimg.png", width: 52, height: 52, fit: BoxFit.cover),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Mark", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    Text("Sedan A1234XG", style: TextStyle(fontSize: 13, color: Color(0xFF3E3E3E))),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 7, left: 12,
            child: GestureDetector(
              onTap: _showReviewModal,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFF8C100),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      'Drive Complete ₹${widget.fare}',
                      style: GoogleFonts.oswald(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 77, left: 49,
            child: Text("Contai", style: TextStyle(fontWeight: FontWeight.w700))
          ),
          Positioned(
            top: 137, left: 49,
            child: Text("Digha", style: TextStyle(fontWeight: FontWeight.w700))
          ),
          Positioned(
            top: 80, left: 30,
            child: Image.asset("assets/icons/Ellipse.png", width: 14, fit: BoxFit.contain),
          ),
          Positioned(
            top: 92, left: 30,
            child: Image.asset("assets/icons/Line.png", width: 14, height: 49, fit: BoxFit.contain),
          ),
          Positioned(
            top: 140, left: 30,
            child: Image.asset("assets/icons/Ellipse.png", width: 14, fit: BoxFit.contain),
          ),
          Positioned(
            top: 70, right: 0,
            child: Image.asset("assets/images/carimg.png", width: 174, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

