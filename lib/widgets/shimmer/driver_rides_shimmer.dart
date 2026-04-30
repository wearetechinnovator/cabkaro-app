import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DriverRidesShimmer extends StatelessWidget {
  const DriverRidesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: const _ShimmerCard(),
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar shimmer
                Shimmer.fromColors(
                  baseColor: const Color(0xFFF0F0F0),
                  highlightColor: const Color(0xFFFFFFFF),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF0F0F0),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name shimmer
                      Shimmer.fromColors(
                        baseColor: const Color(0xFFF0F0F0),
                        highlightColor: const Color(0xFFFFFFFF),
                        child: Container(
                          height: 18,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Date time shimmer
                      Shimmer.fromColors(
                        baseColor: const Color(0xFFF0F0F0),
                        highlightColor: const Color(0xFFFFFFFF),
                        child: Container(
                          height: 14,
                          width: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Fare badge shimmer
                Shimmer.fromColors(
                  baseColor: const Color(0xFFF0F0F0),
                  highlightColor: const Color(0xFFFFFFFF),
                  child: Container(
                    height: 36,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 1,
              color: const Color(0xFFF5F5F5),
            ),
          ),

          // Route section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route indicator dots
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE8E8E8),
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE8E8E8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Locations
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pickup location
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: const Color(0xFFF0F0F0),
                            highlightColor: const Color(0xFFFFFFFF),
                            child: Container(
                              height: 12,
                              width: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Shimmer.fromColors(
                            baseColor: const Color(0xFFF0F0F0),
                            highlightColor: const Color(0xFFFFFFFF),
                            child: Container(
                              height: 16,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Drop location
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: const Color(0xFFF0F0F0),
                            highlightColor: const Color(0xFFFFFFFF),
                            child: Container(
                              height: 12,
                              width: 70,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Shimmer.fromColors(
                            baseColor: const Color(0xFFF0F0F0),
                            highlightColor: const Color(0xFFFFFFFF),
                            child: Container(
                              height: 16,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 1,
              color: const Color(0xFFF5F5F5),
            ),
          ),

          // Bottom action section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left side inputs
                Expanded(
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: const Color(0xFFF0F0F0),
                        highlightColor: const Color(0xFFFFFFFF),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Shimmer.fromColors(
                        baseColor: const Color(0xFFF0F0F0),
                        highlightColor: const Color(0xFFFFFFFF),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Accept button
                Shimmer.fromColors(
                  baseColor: const Color(0xFFF0F0F0),
                  highlightColor: const Color(0xFFFFFFFF),
                  child: Container(
                    height: 54,
                    width: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(16),
                    ),
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