import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cabkaro/controllers/auth_check_controller.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const List<String> _sentences = [
    'How About Todays Destination ?',
    'Where Are We Heading Today ?',
    'Ready For Your Next Ride ?',
    'Let\'s Find You A Cab !',
    'Your Journey Starts Here.',
  ];

  late final AnimationController _shimmerController;
  late final Animation<double> _shimmer;

  int _currentIndex = 0;
  bool _visible = true;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _startCycle();

    Timer(const Duration(seconds: 3), () {
      AuthCheckController.auth(context);
    });
  }

  Future<void> _startCycle() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) break;

      setState(() => _visible = false);
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) break;

      setState(() {
        _currentIndex = (_currentIndex + 1) % _sentences.length;
        _visible = true;
      });

      _shimmerController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Lottie animation
              Builder(
                builder: (context) =>
                    Lottie.asset("assets/animations/splash_loading.json"),
              ).animate().fadeIn(duration: 600.ms),
              const Spacer(),

              // Shimmer cycling text
              Padding(
                padding: const EdgeInsets.only(bottom: 52),
                child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedBuilder(
                    animation: _shimmer,
                    builder: (context, child) {
                      return ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [
                            (_shimmer.value - 0.4).clamp(0.0, 1.0),
                            _shimmer.value.clamp(0.0, 1.0),
                            (_shimmer.value + 0.4).clamp(0.0, 1.0),
                          ],
                          colors: const [
                            Color(0xFF2D2F35),
                            Color(0xFFF8C100),
                            Color(0xFF2D2F35),
                          ],
                        ).createShader(bounds),
                        child: child,
                      );
                    },
                    child: Text(
                      _sentences[_currentIndex],
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D2F35),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
