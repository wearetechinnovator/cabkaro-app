import 'package:flutter/material.dart';
import 'AvailableCabsScreen.dart';
import '../../widgets/listing/cab_list_item_card.dart';
import '../../widgets/listing/listing_bottom_dock.dart';
import '../../widgets/listing/listing_dot_indicator.dart';
import '../../widgets/listing/listing_header.dart';
import '../../widgets/listing/location_search_card.dart';
import '../../widgets/listing/recent_booking_card.dart';
import '../../widgets/listing/review_card.dart';
import '../../widgets/listing/section_title.dart';

class CarListingScreen extends StatelessWidget {
  const CarListingScreen({super.key});

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
              children: const [
                ListingHeader(),
                SizedBox(height: 24),
                _GreetingBlock(),
                SizedBox(height: 14),
                _ListingSearchCard(),
                SizedBox(height: 26),
                SectionTitle(title: 'Available Cabs'),
                SizedBox(height: 12),
                _CabSlider(),
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
                _ReviewSlider(),
                SizedBox(height: 8),
                ListingDotIndicator(activeIndex: 1, count: 3),
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

class _GreetingBlock extends StatelessWidget {
  const _GreetingBlock();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hii Jeena,',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F1F1F),
          ),
        ),
        Text(
          'How About Todays Destination ?',
          style: TextStyle(fontSize: 18, color: Color(0xFF2D2F35)),
        ),
      ],
    );
  }
}

class _ListingSearchCard extends StatelessWidget {
  const _ListingSearchCard();

  @override
  Widget build(BuildContext context) {
    return LocationSearchCard(
      onSubmitWithValues: (request) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AvailableCabsScreen(request: request),
          ),
        );
      },
    );
  }
}

class _CabSlider extends StatelessWidget {
  const _CabSlider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          CabListItemCard(
            driverName: 'Mark',
            carModel: 'Sedan - A1243XY',
            fare: '800 /-',
            eta: '30 Mins',
          ),
          CabListItemCard(
            driverName: 'Harry',
            carModel: 'Sedan - B7732AR',
            fare: '840 /-',
            eta: '25 Mins',
          ),
          CabListItemCard(
            driverName: 'Samar',
            carModel: 'Sedan - D3345TR',
            fare: '760 /-',
            eta: '34 Mins',
          ),
        ],
      ),
    );
  }
}

class _ReviewSlider extends StatelessWidget {
  const _ReviewSlider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 194,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          ReviewCard(
            name: 'Merry',
            role: 'Student',
            rating: '4.5',
            comment:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since.',
          ),
          ReviewCard(
            name: 'Noah',
            role: 'Designer',
            rating: '4.8',
            comment:
                'Professional driver, clean car and perfect timing. The whole ride felt smooth and safe for city travel.',
          ),
          ReviewCard(
            name: 'Ava',
            role: 'Founder',
            rating: '4.6',
            comment:
                'Booking was quick and transparent. I liked the route update and the comfort level during peak traffic.',
          ),
        ],
      ),
    );
  }
}
