import 'package:flutter/material.dart';

class ListingDotIndicator extends StatelessWidget {
  const ListingDotIndicator({
    super.key,
    required this.activeIndex,
    required this.count,
  });

  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: index == activeIndex ? 30 : 16,
          height: 6,
          decoration: BoxDecoration(
            color: index == activeIndex
                ? const Color(0xFFF8C100)
                : const Color(0xFF2D2F35),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
