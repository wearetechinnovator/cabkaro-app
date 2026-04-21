import 'package:cabkaro/controllers/user/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GreetingBlock extends StatefulWidget {
  const GreetingBlock({super.key});

  @override
  State<GreetingBlock> createState() => _GreetingBlockState();
}

class _GreetingBlockState extends State<GreetingBlock>
    with SingleTickerProviderStateMixin {
  static const List<String> _sentences = [
    'How About Todays Destination ?',
    'Where Are We Heading Today ?',
    'Ready For Your Next Ride ?',
    'Let\'s Find You A Cab !',
    'Your Journey Starts Here.',
  ];

  late final AnimationController _controller;
  late final Animation<double> _shimmer;

  int _currentIndex = 0;
  bool _visible = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _shimmer = Tween<double>(
      begin: -1.5,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startCycle();
  }

  Future<void> _startCycle() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) break;

      // Fade out
      setState(() => _visible = false);
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) break;

      // Swap text
      setState(() {
        _currentIndex = (_currentIndex + 1) % _sentences.length;
        _visible = true;
      });

      // Run shimmer
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EditProfileController>();
    final name = controller.userData?['name'].split(" ")[0] ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: GoogleFonts.oswald(
            fontSize: 38,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2F35),
          ),
        ),
        const SizedBox(height: 2),
        AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 350),
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
                    Color(0xFFF8C100), // your app's yellow accent
                    Color(0xFF2D2F35),
                  ],
                ).createShader(bounds),
                child: child,
              );
            },
            child: Text(
              _sentences[_currentIndex],
              style: GoogleFonts.notoSans(
                fontSize: 18,
                color: const Color(0xFF2D2F35),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
