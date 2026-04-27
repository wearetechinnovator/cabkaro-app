import 'package:flutter/material.dart';
import 'dart:math' as math;

class DriverSearchingScreen extends StatefulWidget {
  const DriverSearchingScreen({super.key});

  @override
  State<DriverSearchingScreen> createState() => _DriverSearchingScreenState();
}

class _DriverSearchingScreenState extends State<DriverSearchingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _dotController;

  late Animation<double> _pulse1;
  late Animation<double> _pulse2;
  late Animation<double> _pulse3;
  late Animation<double> _rotate;
  late Animation<double> _dotFade;

  int _dotCount = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();

    _pulse1 = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _pulse2 = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    _pulse3 = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
      ),
    );

    _rotate = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    _dotFade = Tween<double>(begin: 0.0, end: 1.0).animate(_dotController);

    _dotController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _dotCount = (_dotCount + 1) % 4);
        _dotController.reset();
        _dotController.forward();
      }
    });
    _dotController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1C21),
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.2),
                    radius: 1.2,
                    colors: [Color(0xFF2D2F35), Color(0xFF1A1C21)],
                  ),
                ),
              ),
            ),

            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2F35),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Radar animation
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Pulse ring 3 (outermost)
                            Opacity(
                              opacity: (1 - _pulse3.value) * 0.3,
                              child: Container(
                                width: 260 * _pulse3.value,
                                height: 260 * _pulse3.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFF8C100),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            // Pulse ring 2
                            Opacity(
                              opacity: (1 - _pulse2.value) * 0.5,
                              child: Container(
                                width: 200 * _pulse2.value,
                                height: 200 * _pulse2.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFF8C100),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            // Pulse ring 1
                            Opacity(
                              opacity: (1 - _pulse1.value) * 0.7,
                              child: Container(
                                width: 140 * _pulse1.value,
                                height: 140 * _pulse1.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFF8C100),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            // Rotating sweep
                            AnimatedBuilder(
                              animation: _rotate,
                              builder: (context, _) {
                                return Transform.rotate(
                                  angle: _rotate.value,
                                  child: CustomPaint(
                                    size: const Size(200, 200),
                                    painter: _RadarSweepPainter(),
                                  ),
                                );
                              },
                            ),

                            // Center car icon
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D2F35),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFF8C100,
                                    ).withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color(0xFFF8C100),
                                  width: 2.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.local_taxi_rounded,
                                color: Color(0xFFF8C100),
                                size: 36,
                              ),
                            ),

                            // Floating driver dots
                            ..._buildDriverDots(size),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Searching text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Searching for drivers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 2),
                      SizedBox(
                        width: 36,
                        child: Text(
                          '.' * _dotCount,
                          style: const TextStyle(
                            color: Color(0xFFF8C100),
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Please wait while we find the\nbest driver near you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Trip details card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2F35),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.06),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _TripPoint(
                            icon: Icons.radio_button_checked,
                            iconColor: const Color(0xFF4CAF50),
                            label: 'Pickup',
                            value: '69 New New York, USA',
                          ),

                          
                          _TripPoint(
                            icon: Icons.location_on_rounded,
                            iconColor: const Color(0xFFF8C100),
                            label: 'Drop',
                            value: 'Digha, West Bengal',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Estimated fare
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8C100).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFF8C100).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.currency_rupee_rounded,
                                color: Color(0xFFF8C100),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Estimated Fare',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            '₹800',
                            style: TextStyle(
                              color: Color(0xFFF8C100),
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Cancel button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2F35),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        'Cancel Ride',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDriverDots(Size size) {
    final positions = [
      const Offset(65, -50),
      const Offset(-70, 30),
      const Offset(50, 70),
      const Offset(-40, -70),
    ];

    return positions.asMap().entries.map((e) {
      final i = e.key;
      final pos = e.value;
      return Positioned(
        left: 130 + pos.dx - 8,
        top: 130 + pos.dy - 8,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            final phase = (_pulseController.value + i * 0.25) % 1.0;
            return Opacity(
              opacity: 0.4 + (math.sin(phase * math.pi) * 0.6),
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8C100),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF8C100).withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: Color(0xFF1A1C21),
                  size: 10,
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }
}

class _RadarSweepPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: math.pi / 2,
      colors: [
        const Color(0xFFF8C100).withOpacity(0.0),
        const Color(0xFFF8C100).withOpacity(0.15),
      ],
    );

    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TripPoint extends StatelessWidget {
  const _TripPoint({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
