import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../widgets/listing/listing_bottom_dock.dart';
import '../../widgets/driver/driver_bottom_dock.dart';

class DriverNoRidesScreen extends StatefulWidget {
  const DriverNoRidesScreen({super.key});

  @override
  State<DriverNoRidesScreen> createState() => _DriverNoRidesScreenState();
}

class _DriverNoRidesScreenState extends State<DriverNoRidesScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _radarController;
  late AnimationController _shimmerController;
  late AnimationController _staggerController;

  late Animation<double> _floatAnim;
  late Animation<double> _radarAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _staggerAnim;

  bool _isOnline = true;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _radarAnim = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _radarController, curve: Curves.linear),
    );

    _shimmerAnim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _staggerAnim = CurvedAnimation(
      parent: _staggerController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _radarController.dispose();
    _shimmerController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Scrollable body ──────────────────────────────────────
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              children: [
                // Header
                const _DriverHeader(),
                const SizedBox(height: 24),

                // Title row
                FadeTransition(
                  opacity: _staggerAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_staggerAnim),
                    child: const Text(
                      'Driver Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1F1F),
                        height: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Online / Offline toggle card ──────────────────────
                _OnlineToggleCard(
                  isOnline: _isOnline,
                  onToggle: (v) => setState(() => _isOnline = v),
                ),

                const SizedBox(height: 28),

                // ── Central empty-state illustration ─────────────────
                AnimatedBuilder(
                  animation: _floatAnim,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnim.value),
                      child: child,
                    );
                  },
                  child: _RadarIllustration(
                    radarAnim: _radarAnim,
                    shimmerAnim: _shimmerAnim,
                    isOnline: _isOnline,
                    size: screenWidth - 80,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Status message ────────────────────────────────────
                _StatusMessage(isOnline: _isOnline),

                const SizedBox(height: 32),

                // ── Stats row ─────────────────────────────────────────
                _StatsRow(staggerAnim: _staggerAnim),

                const SizedBox(height: 28),

                // ── Tips carousel ─────────────────────────────────────
                const _TipsSection(),
              ],
            ),

            // ── Bottom dock ───────────────────────────────────────────
            Positioned(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              bottom: 16,
              // child: const ListingBottomDock(),
              child: const DriverBottomDock(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header  (same style as DriverHomeScreen)
// ─────────────────────────────────────────────────────────────────────────────

class _DriverHeader extends StatelessWidget {
  const _DriverHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderCircle(icon: Icons.grid_view_rounded),
        const Spacer(),
        _HeaderCircle(
          icon: Icons.notifications_none_rounded,
          onTap: () => Navigator.pushNamed(context, '/notifications'),
        ),
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFFD24A61),
          child: Text(
            'M',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Online / Offline Toggle Card
// ─────────────────────────────────────────────────────────────────────────────

class _OnlineToggleCard extends StatelessWidget {
  const _OnlineToggleCard({required this.isOnline, required this.onToggle});
  final bool isOnline;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: isOnline ? const Color(0xFF2D2F35) : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline
              ? const Color(0xFFF8C100).withOpacity(0.4)
              : const Color(0xFF2D2F35).withOpacity(0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isOnline
                ? const Color(0xFFF8C100).withOpacity(0.18)
                : Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isOnline
                  ? const Color(0xFFF8C100)
                  : const Color(0xFFDDDDDD),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              color: isOnline ? const Color(0xFF2D2F35) : const Color(0xFF888888),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isOnline ? Colors.white : const Color(0xFF1F1F1F),
                  ),
                  child: Text(isOnline ? 'You\'re Online' : 'You\'re Offline'),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 12,
                    color: isOnline
                        ? Colors.white.withOpacity(0.55)
                        : const Color(0xFF888888),
                  ),
                  child: Text(
                    isOnline
                        ? 'Waiting for ride requests nearby'
                        : 'Go online to start receiving rides',
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onToggle(!isOnline),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 52,
              height: 28,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isOnline
                    ? const Color(0xFFF8C100)
                    : const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isOnline
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isOnline ? const Color(0xFF2D2F35) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Radar Illustration  (the hero empty-state graphic)
// ─────────────────────────────────────────────────────────────────────────────

class _RadarIllustration extends StatelessWidget {
  const _RadarIllustration({
    required this.radarAnim,
    required this.shimmerAnim,
    required this.isOnline,
    required this.size,
  });

  final Animation<double> radarAnim;
  final Animation<double> shimmerAnim;
  final bool isOnline;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer decorative ring
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2D2F35).withOpacity(0.08),
                  width: 1,
                ),
              ),
            ),
            Container(
              width: size * 0.75,
              height: size * 0.75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2D2F35).withOpacity(0.12),
                  width: 1,
                ),
              ),
            ),
            Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2D2F35).withOpacity(0.16),
                  width: 1,
                ),
              ),
            ),

            // Rotating sweep (only when online)
            if (isOnline)
              AnimatedBuilder(
                animation: radarAnim,
                builder: (context, _) => Transform.rotate(
                  angle: radarAnim.value,
                  child: CustomPaint(
                    size: Size(size * 0.75, size * 0.75),
                    painter: _SweepPainter(),
                  ),
                ),
              ),

            // Center car card
            AnimatedBuilder(
              animation: shimmerAnim,
              builder: (context, child) {
                return Container(
                  width: size * 0.38,
                  height: size * 0.38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2F35),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isOnline
                            ? const Color(0xFFF8C100).withOpacity(0.35)
                            : Colors.black.withOpacity(0.15),
                        blurRadius: isOnline ? 28 : 12,
                        spreadRadius: isOnline ? 4 : 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_taxi_rounded,
                        color: isOnline
                            ? const Color(0xFFF8C100)
                            : Colors.white.withOpacity(0.4),
                        size: size * 0.12,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isOnline ? 'Searching' : 'Offline',
                        style: TextStyle(
                          color: isOnline
                              ? const Color(0xFFF8C100)
                              : Colors.white.withOpacity(0.3),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Tiny location pin decorations around the ring
            if (isOnline)
              ..._buildOrbitIcons(size),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOrbitIcons(double size) {
    final radius = size * 0.37;
    final items = [
      (angle: 30.0, icon: Icons.location_on_rounded, color: const Color(0xFFD24A61)),
      (angle: 130.0, icon: Icons.person_pin_circle_rounded, color: const Color(0xFF4CAF50)),
      (angle: 230.0, icon: Icons.location_on_rounded, color: const Color(0xFF2196F3)),
    ];

    return items.map((item) {
      final rad = item.angle * math.pi / 180;
      final x = radius * math.cos(rad);
      final y = radius * math.sin(rad);
      return Positioned(
        left: size / 2 + x - 14,
        top: size / 2 + y - 14,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: item.color.withOpacity(0.5), width: 1),
          ),
          child: Icon(item.icon, color: item.color, size: 14),
        ),
      );
    }).toList();
  }
}

class _SweepPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: math.pi / 2,
        colors: [
          const Color(0xFFF8C100).withOpacity(0.0),
          const Color(0xFFF8C100).withOpacity(0.18),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Message
// ─────────────────────────────────────────────────────────────────────────────

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.isOnline});
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Column(
        key: ValueKey(isOnline),
        children: [
          Text(
            isOnline ? 'No rides yet' : 'You\'re taking a break',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isOnline
                ? 'Hang tight — your next ride is on its\nway to you. Stay ready! 🚕'
                : 'Toggle online above when you\'re\nready to hit the road again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF1F1F1F).withOpacity(0.5),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats Row
// ─────────────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.staggerAnim});
  final Animation<double> staggerAnim;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: staggerAnim,
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Today\'s Earnings',
              value: '₹0',
              icon: Icons.currency_rupee_rounded,
              color: const Color(0xFFF8C100),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Rides Today',
              value: '0',
              icon: Icons.route_rounded,
              color: const Color(0xFFD24A61),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Rating',
              value: '4.9',
              icon: Icons.star_rounded,
              color: const Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFF1F1F1F).withOpacity(0.45),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tips Section
// ─────────────────────────────────────────────────────────────────────────────

class _TipsSection extends StatelessWidget {
  const _TipsSection();

  static const _tips = [
    (
      icon: Icons.bolt_rounded,
      title: 'Peak Hours',
      body: 'Rides surge between 8–10 AM and 5–8 PM. Stay online then!',
      color: Color(0xFFF8C100),
    ),
    (
      icon: Icons.map_rounded,
      title: 'Hot Zones',
      body: 'Station areas & malls get the most requests. Position wisely.',
      color: Color(0xFF2196F3),
    ),
    (
      icon: Icons.star_half_rounded,
      title: 'Boost Your Rating',
      body: 'A clean car and a friendly smile earns 5-star reviews.',
      color: Color(0xFF4CAF50),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pro Tips',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 12),
        ..._tips.map(
          (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _TipCard(
              icon: tip.icon,
              title: tip.title,
              body: tip.body,
              color: tip.color,
            ),
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF1F1F1F).withOpacity(0.5),
                    height: 1.4,
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