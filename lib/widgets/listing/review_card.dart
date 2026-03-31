import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.name,
    required this.role,
    required this.rating,
    required this.comment,
  });

  final String name;
  final String role;
  final String rating;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
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
              const _Avatar(),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(role, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8C100),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 16),
                    const SizedBox(width: 6),
                    Text(rating, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF39A47),
      ),
      alignment: Alignment.center,
      child: const Text(
        'M',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}
