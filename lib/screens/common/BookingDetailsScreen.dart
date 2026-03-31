import 'package:flutter/material.dart';

import '../../widgets/listing/listing_bottom_dock.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              children: const [
                _HeaderRow(),
                SizedBox(height: 24),
                Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                    height: 1,
                  ),
                ),
                SizedBox(height: 16),
                _BookingCard(),
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

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _HeaderCircle(icon: Icons.grid_view_rounded),
        const Spacer(),
        _HeaderCircle(
          icon: Icons.notifications_none_rounded,
          onTap: () => Navigator.pushNamed(context, '/notifications'),
        ),
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFFD24A61),
          backgroundImage: AssetImage('assets/images/avatar.png'),
        ),
      ],
    );
  }
}

class _HeaderCircle extends StatelessWidget {
  const _HeaderCircle({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF2D2F35), width: 1.2),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF2D2F35)),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4E5B0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D2F35), width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0xFF4D4D4D), offset: Offset(2, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE6A64E),
                          image: DecorationImage(
                            image: AssetImage('assets/images/avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Jeena',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 126,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8C100),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(22),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '30 Dec\n9:30 A.M',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(
                  child: Column(
                    children: [
                      _VerticalRoute(),
                      SizedBox(height: 10),
                      _CallButton(),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 78,
                  height: 78,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1DA20B),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: -0.35,
                    child: const Text(
                      'Ride\nBooked',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2F35),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Fair - ₹ 800 /-',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        'assets/images/yelloCarTest.png',
                        height: 82,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalRoute extends StatelessWidget {
  const _VerticalRoute();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 6),
        Column(
          children: [
            _Dot(),
            SizedBox(
              width: 2,
              height: 32,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFF3D3D3D)),
              ),
            ),
            _Dot(),
          ],
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contai',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 28),
            Text(
              'Digha',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF8C100),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.call, size: 17, color: Color(0xFF1F1F1F)),
          SizedBox(width: 6),
          Text(
            'Call : 890 00 0000',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

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
