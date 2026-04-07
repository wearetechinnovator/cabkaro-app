import 'package:cabkaro/screens/driver/DriverScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cabkaro/screens/user/SignupScreen.dart';
import '../../widgets/GradientBackground.dart';
import '../../widgets/ActionButton.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final isSmallScreen = screenHeight < 600;

    return Scaffold(
      body: GradientBackground(
        showGlow: false,
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: horizontalPadding),
                  child: SvgPicture.asset(
                    'assets/icons/cabkaroLogo.svg',
                    width: 133,
                    height: 40,
                  ),
                ),
              ),
              
              SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "Find Your Dream\nTaxi To Start Your Journey",
                  style: GoogleFonts.oswald(
                    fontSize: screenWidth * 0.0800,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "Start your ride with comfort and confidence - book reliable taxis anytime, anywhere.",
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    color: Colors.black,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              
              Align(
                alignment: Alignment.centerRight,
                child: Transform.translate(
                  offset: const Offset(34, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(38, 0, 0, 0),
                          blurRadius: 80,
                          spreadRadius: 1,
                          offset: Offset(100, 70),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child:
                        Image.asset(
                              'assets/images/yellowCar.png',
                              width: screenWidth * 1.0,
                              height: screenHeight * 0.250,
                              fit: BoxFit.contain,
                            )
                            .animate(autoPlay: true) 
                            .slideX(begin: 0.5, end: 0, duration: 400.ms)
                            .fadeIn(duration: 300.ms),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.17),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ActionButton(
                  label: 'Post Your Journey',
                  backgroundColor: const Color.fromARGB(255, 242, 202, 42),
                  textColor: Colors.black,
                  borderColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ActionButton(
                  label: "I'm Driver",
                  backgroundColor: const Color.fromARGB(255, 242, 202, 42),
                  textColor: const Color.fromARGB(255, 0, 0, 0),
                  borderColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DriverScreen(),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
