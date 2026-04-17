import 'package:flutter/material.dart';
import 'package:cabkaro/screens/user/user_listing_dock.dart';
import 'package:cabkaro/widgets/reviewslider/review_slider.dart';
import 'package:cabkaro/screens/user/available_cabs_screen.dart';
import '../../widgets/listing/listing_dot_indicator.dart';
import '../../widgets/listing/listing_header.dart';
import '../../widgets/listing/recent_booking_card.dart';
import '../../widgets/listing/section_title.dart';
import '../../widgets/search_card.dart';
import '../../widgets/cabslider/cabslider.dart';
import 'greeting_block.dart';

class CarListingScreen extends StatefulWidget {
  const CarListingScreen({super.key});

  @override
  State<CarListingScreen> createState() => _CarListingScreenState();
}

class _CarListingScreenState extends State<CarListingScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 120.0),
                children: [
                  const ListingHeader(),
                  const SizedBox(height: 24.0),
                  const GreetingBlock(),
                  const SizedBox(height: 14.0),
                  Searchcard(
                    onSubmit: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const AvailableCabsScreen();
                      }));
                    },
                  ),
                  const SizedBox(height: 26.0),
                  const SectionTitle(title: 'Available Cabs'),
                  const SizedBox(height: 12.0),
                  const CabSlider(),
                  const SizedBox(height: 12.0),
                  const ListingDotIndicator(activeIndex: 0, count: 3),
                  const SizedBox(height: 22.0),
                  const SectionTitle(title: 'Recent Booking'),
                  const SizedBox(height: 12.0),
                  const RecentBookingCard(
                    customer: 'Nishan',
                    pickup: '69 New New York, USA',
                    drop: 'Digha',
                    fare: '₹800',
                  ),
                  const SizedBox(height: 22.0),
                  const SectionTitle(title: 'Reviews'),
                  const SizedBox(height: 12.0),
                  const ReviewSlider(),
                  const SizedBox(height: 8.0),
                  const ListingDotIndicator(activeIndex: 1, count: 3),
                ],
              ),
            ),
            Positioned(
              left: size.width * 0.07,
              right: size.width * 0.07,
              bottom: 16.0,
              child: const UserListingDock(),
            ),
          ],
        ),
      ),
    );
  }
}