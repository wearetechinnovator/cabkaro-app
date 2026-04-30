import 'package:cabkaro/screens/common/login_screen.dart';
import 'package:cabkaro/screens/user/signin_screen.dart';
import 'package:cabkaro/services/location_permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/action_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    // Request location permission on first app open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocationPermissionService.requestLocationPermission(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    // final isSmallScreen = screenHeight < 600;

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
                  onTap: () async {
                    final SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString("role", "user");

                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ActionButton(
                  label: "Drive a Journey",
                  backgroundColor: const Color.fromARGB(255, 21, 21, 19),
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  borderColor: const Color(0xFF1F1F1F),
                  onTap: () async {
<<<<<<< HEAD
                    final SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString("role", "driver");
=======
                    final SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.setString("role", "vendor");
>>>>>>> a64f8e0 (Edit vendor and user profile)

                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
<<<<<<< HEAD
                        builder: (context) => const LoginScreen() ,
=======
                        builder: (context) => const LoginScreen(),
>>>>>>> a64f8e0 (Edit vendor and user profile)
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
