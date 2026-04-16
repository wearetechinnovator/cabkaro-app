import 'package:cabkaro/screens/user/user_listing_dock.dart';
import 'package:cabkaro/widgets/reviewslider/review_slider.dart';
import 'package:flutter/material.dart';
// import '../../widgets/listing/listing_bottom_dock.dart';
import '../../widgets/listing/listing_dot_indicator.dart';
import '../../widgets/listing/listing_header.dart';
import '../../widgets/listing/recent_booking_card.dart';
import 'greeting_block.dart';
import '../../widgets/listing/section_title.dart';
import '../../widgets/search_card.dart';
import '../../widgets/cabslider/cabslider.dart';
import 'package:cabkaro/screens/user/available_cabs_screen.dart';

class CarListingScreen extends StatefulWidget {
  const CarListingScreen({super.key});

  @override
  State<CarListingScreen> createState() => _CarListingScreenState();
}

class _CarListingScreenState extends State<CarListingScreen> {
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
                ListingHeader(),
                SizedBox(height: 24),
                GreetingBlock(),
                SizedBox(height: 14),
                // _ListingSearchCard(),
                
                Searchcard(
                  onSubmit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvailableCabsScreen(),
                      ),
                    );
                  },
                  
                ),
                SizedBox(height: 26),
                SectionTitle(title: 'Available Cabs'),
                SizedBox(height: 12),
                CabSlider(),
                SizedBox(height: 12),
                ListingDotIndicator(activeIndex: 0, count: 3),
                SizedBox(height: 22),
                SectionTitle(title: 'Recent Booking'),
                SizedBox(height: 12),
                RecentBookingCard(
                  customer: 'Nishan',
                  pickup: '69 New New York, USA',
                  drop: 'Digha',
                  fare: '₹800',
                ),
                SizedBox(height: 22),
                SectionTitle(title: 'Reviews'),
                SizedBox(height: 12),
                ReviewSlider(),
                SizedBox(height: 8),
                ListingDotIndicator(activeIndex: 1, count: 3),
              ],
              
            ),
            
            Positioned(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              bottom: 16,
              child: const UserListingDock(),
            ),
            
          ],
        ),
        
      ),
      
    );
  }
}