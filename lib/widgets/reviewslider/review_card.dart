import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.name,
    required this.role,
    required this.rating,
    required this.comment,
    required this.image,

  });

  final String name;
  final String role;
  final String rating;
  final String comment;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 0),
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(image: image),
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
  final String image; // add this

  const _Avatar({required this.image}); 

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
      child: Image(image: AssetImage(image)),
    );
  }
}
