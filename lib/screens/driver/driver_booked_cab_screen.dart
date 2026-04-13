import 'package:flutter/material.dart';

import '../../widgets/listing/listing_bottom_dock.dart';

class DriverBookedCabScreen extends StatefulWidget {
  const DriverBookedCabScreen({super.key});

  @override
  State<DriverBookedCabScreen> createState() => _DriverBookedCabScreenState();
}

class _DriverBookedCabScreenState extends State<DriverBookedCabScreen> {
  String? _decision;

  void _handleAccept() {
    setState(() {
      _decision = 'accepted';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ride request accepted')),
    );
  }

  void _handleReject() {
    setState(() {
      _decision = 'rejected';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ride request rejected')),
    );
  }

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
                const _DriverHeader(),
                const SizedBox(height: 24),
                const Text(
                  'Driver Dashboard',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F1F1F),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 14),
                _DriverBookedCard(
                  userName: 'Jeena',
                  fareText: '800',
                  estimateText: '2Hrs.',
                  isPrimary: true,
                  decision: _decision,
                  onAccept: _handleAccept,
                  onReject: _handleReject,
                ),
                const SizedBox(height: 14),
                const _DriverBookedCard(
                  userName: 'Jeena',
                  fareText: 'Price',
                  estimateText: 'Estimate Time',
                  waitText: 'Accept',
                  isPrimary: false,
                ),
                const SizedBox(height: 14),
                const _DriverBookedCard(
                  userName: 'Jeena',
                  fareText: 'Price',
                  estimateText: 'Estimate Time',
                  waitText: 'Accept',
                  isPrimary: false,
                ),
                const SizedBox(height: 14),
                const _DriverBookedCard(
                  userName: 'Jeena',
                  fareText: 'Price',
                  estimateText: 'Estimate Time',
                  waitText: 'Accept',
                  isPrimary: false,
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

class _DriverHeader extends StatelessWidget {
  const _DriverHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _HeaderCircle(icon: Icons.grid_view_rounded),
        const Spacer(),
        const _HeaderCircle(icon: Icons.notifications_none_rounded),
        const SizedBox(width: 12),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFF8C100), Color(0xFFD24A61)],
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            'M',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderCircle extends StatelessWidget {
  const _HeaderCircle({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2D2F35), width: 1.2),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 20, color: const Color(0xFF2D2F35)),
    );
  }
}

class _DriverBookedCard extends StatelessWidget {
  const _DriverBookedCard({
    required this.userName,
    required this.fareText,
    required this.estimateText,
    this.waitText,
    required this.isPrimary,
    this.decision,
    this.onAccept,
    this.onReject,
  });

  final String userName;
  final String fareText;
  final String estimateText;
  final String? waitText;
  final bool isPrimary;
  final String? decision;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4E5B0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 23, 25, 32), width: 1.2),
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
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'J',
                          style: TextStyle(
                            color: Color(0xFF2D2F35),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        userName,
                        style: const TextStyle(
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8C100),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(22),
                  ),
                ),
                transform: Matrix4.translationValues(0, -9, 0),
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
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _ChipInput(
                        icon: Icons.currency_rupee_rounded,
                        text: fareText,
                      ),
                      const SizedBox(height: 8),
                      _ChipInput(
                        icon: Icons.access_time_rounded,
                        text: estimateText,
                      ),
                      const SizedBox(height: 10),
                      isPrimary
                          ? _DecisionButtons(
                              decision: decision,
                              onAccept: onAccept,
                              onReject: onReject,
                            )
                          : _StateButton(text: waitText ?? 'Accept'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _FarePill(fare: '800 /-'),
                    SizedBox(height: 20),
                    _RouteLine(),
                  ],
                ),
              ],
            ),
            
          ),
          
        ],
      ),
    );

    if (isPrimary) {
      return card;
    }

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0, 0, 0, 1, 0,
      ]),
      child: card,
    );
  }
}

class _ChipInput extends StatelessWidget {
  const _ChipInput({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF66635A), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF3F3F3F)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF2F2F2F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StateButton extends StatelessWidget {
  const _StateButton({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8C100),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _DecisionButtons extends StatelessWidget {
  const _DecisionButtons({
    required this.decision,
    this.onAccept,
    this.onReject,
  });

  final String? decision;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final accepted = decision == 'accepted';
    final rejected = decision == 'rejected';

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          _DecisionButton(
            label: 'Accept',
            color: const Color(0xFFF8C100),
            isActive: accepted,
            onTap: onAccept,
          ),
          const SizedBox(width: 8),
          _DecisionButton(
            label: 'Reject',
            color: const Color(0xFFC91818),
            isActive: rejected,
            onTap: onReject,
          ),
        ],
      ),
    );
  }
}

class _DecisionButton extends StatelessWidget {
  const _DecisionButton({
    required this.label,
    required this.color,
    required this.isActive,
    this.onTap,
  });

  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 36,
        width: 86,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: isActive
              ? Border.all(color: const Color(0xFF2D2F35), width: 1.4)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _FarePill extends StatelessWidget {
  const _FarePill({required this.fare});

  final String fare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2F35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Fair - ₹ $fare',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RouteLine extends StatelessWidget {
  const _RouteLine();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _Dot(),
              SizedBox(width: 8),
              Expanded(
                child: Divider(
                  color: Color(0xFF3D3D3D),
                  thickness: 2,
                  height: 2,
                ),
              ),
              SizedBox(width: 8),
              _Dot(),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contai',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                'Digha',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
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
