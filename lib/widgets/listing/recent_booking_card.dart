import 'package:flutter/material.dart';

class RecentBookingCard extends StatelessWidget {
  const RecentBookingCard({
    super.key,
    required this.customer,
    required this.pickup,
    required this.drop,
    required this.fare,
  });

  final String customer;
  final String pickup;
  final String drop;
  final String fare;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E5B0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2D2F35), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SmallAvatar(initials: 'N'),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  customer,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const Icon(Icons.access_time_rounded, size: 16),
              const SizedBox(width: 6),
              const Text('8 min', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 4),
              const Icon(Icons.radio_button_checked, size: 12),
              const SizedBox(width: 8),
              Expanded(child: Text(pickup, style: const TextStyle(fontSize: 13))),
            ],
          ),
          const SizedBox(height: 1),
          const Padding(
            padding: EdgeInsets.only(left: 3),
            child: SizedBox(
              height: 16,
              child: VerticalDivider(color: Color(0xFF2D2F35), thickness: 1),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 4),
              const Icon(Icons.location_on_rounded, size: 14),
              const SizedBox(width: 8),
              Expanded(child: Text(drop, style: const TextStyle(fontSize: 13))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8C100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Drive Complete',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              Text(
                fare,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallAvatar extends StatelessWidget {
  const _SmallAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFEA5A5A),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}
