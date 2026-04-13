import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.showGlow = true,
  });

  final Widget child;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF6F6F8),
            Color(0xFFF8E8B6),
            Color(0xFFF8C100),
          ],
          stops: [0.0, 0.66, 1.0],
        ),
      ),
      child: showGlow
          ? Stack(
              children: [
                Positioned(
                  top: 140,
                  left: -30,
                  right: -30,
                  child: IgnorePointer(
                    child: Container(
                      height: 380,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xCCFFD96A),
                            Color(0x00FFD96A),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -130,
                  left: -35,
                  right: -35,
                  child: IgnorePointer(
                    child: Container(
                      height: 430,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xB3FFD137),
                            Color(0x00FFD137),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                child,
              ],
            )
          : child,
    );
  }
}
